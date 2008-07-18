<cfcomponent output="false">
	
	<cfset instance = structNew() />
	
	<cffunction name="init" access="public" output="false">
		<cfargument name="OriginalObject" required="true" />
		<cfargument name="initialState" type="string" required="true" />
		<cfargument name="stateMethod" type="string" required="false" default="state" />
		<cfscript>
			setOriginalObject(arguments.OriginalObject);
			instance.states = structNew();
			instance.transitionTable = structNew();
			instance.eventTable = structNew();
			instance.stateMethod = arguments.stateMethod;			
			instance.initialState = arguments.initialState;
						
			configureState();
			setInitialState(instance.initialState);
						
			return this;
		</cfscript>
	</cffunction>
	
	<!--- Builds the state and event from the configuration --->
	
	<cffunction name="addState" access="private" output="false">
		<cfargument name="name" type="string" required="true" />
		<cfset var state = createObject("component", "shade.State").init(arguments.name) />
		<cfset instance.states[arguments.name] = state />
		<cfreturn state />
	</cffunction>
	
	<cffunction name="addEvent" access="private" output="false">
		<cfargument name="name" type="string" required="true" />
		<cfset var event = createObject("component", "shade.Event").init(arguments.name, instance.transitionTable) />
		<cfset instance.eventTable[arguments.name] = event />
		<cfreturn event />
	</cffunction>
	
	<!--- Handles firing events --->
	
	<cffunction name="fireEvent" access="public" output="false">
		<cfargument name="name" type="string" required="true" />
		<cfif structKeyExists(instance.eventTable, arguments.name)>
			<cfreturn instance.eventTable[arguments.name].fire(this) />
		</cfif>
		<cfreturn false />
	</cffunction>
	
	
	<!--- Holds a reference to the object that is being decorated --->
	
	<cffunction name="getOriginalObject" access="public" output="false">
		<cfreturn instance.OriginalObject />
	</cffunction>
	
	<cffunction name="setOriginalObject" access="public" output="false">
		<cfargument name="object" required="true" />	
		<cfset instance.OriginalObject = arguments.object />
	</cffunction>
	
	<!--- Gets the current value of the state method from the decorated class --->
	
	<cffunction name="getState" access="public" output="false">
		<cfreturn invokeMethod("get#instance.stateMethod#") />
	</cffunction>
	
	<cffunction name="setState" access="public" output="false">
		<cfargument name="state" type="string" required="true" />	
		<cfset var local = structNew() />
		<cfset local.state = arguments.state />
		<cfset invokeMethod("set#instance.stateMethod#", local) />
	</cffunction>

	<!--- Accessors --->
	
	<cffunction name="getInitialState" access="public" returntype="string" output="false">
		<cfreturn instance.initialState />
	</cffunction>
	
	<!--- This should only be called once during init --->
	
	<cffunction name="setInitialState" access="private" output="false">
		<cfargument name="stateName" required="true" />
		<cfscript>
			var state = instance.states[arguments.stateName];
			state.before(this);
			setState(arguments.stateName);
			state.after(this);
		</cfscript>
	</cffunction>	
	
	<cffunction name="getCurrentState" access="public" returntype="string" output="false">
		<cfreturn invokeMethod("get#instance.stateMethod#") />
	</cffunction>
	
	<cffunction name="getStateMethod" access="public" returntype="string" output="false">
		<cfreturn instance.stateMethod />
	</cffunction>
		
	<cffunction name="getTransitionTable" access="public" returntype="struct" output="false">
		<cfreturn instance.transitionTable />
	</cffunction>
	
	<cffunction name="getEventTable" access="public" returntype="string" output="false">
		<cfreturn instance.eventTable />
	</cffunction>
	
	<cffunction name="getStates" access="public" returntype="struct" output="false">
		<cfreturn instance.states />
	</cffunction>
	
	<cffunction name="isInState" access="public" returntype="boolean" output="false">
		<cfargument name="state" type="string" required="true" />
		<cfreturn state eq getCurrentState() />
	</cffunction>
	
	<!--- Returns what the next state for a given event would be, as a string. --->
	
	<cffunction name="getNextStateForEvent" access="public" returntype="string" output="false">
		<cfargument name="event" type="string" required="true" />
		<cfset var transitions = instance.transitionTable[arguments.event] />
		<cfset var transition = '' />
		
		<cfset transitions.reset() />
		<cfloop condition="transitions.hasNext()">
			<cfset transition = transitions.next() />
			<cfif transition.getFromState() eq getCurrentState()>
				<cfreturn transition.getToState() />
			</cfif>
		</cfloop>
		<cfreturn '' />
	</cffunction>
	
	<!--- 
	We are using onMissingMethod for three things:
	
		1. To defined the state query handlers, i.e. isClosed()
		2. To define the event firing shortcuts, i.e. close()
		3. To pass any unknown method on to the decorated object to handle
				
	--->	
	<cffunction name="onMissingMethod" output="false" access="public">
    <cfargument name="missingMethodName" type="string" />
    <cfargument name="missingMethodArguments" type="struct" />
		
		<!--- 
		Shortcut to wire up event methods, so basically if you have a 
		'trash' event, you can call obj.trash() rather than the longer obj.fireEvent('trash') --->
		<cfif structKeyExists(instance.eventTable, arguments.missingMethodName)>
			<cfreturn fireEvent(arguments.missingMethodName) />		
		</cfif>
		
		<!--- Adds query methods. For and event 'trash', this will allow you to call isTrash() --->
		<cfset stateList = structKeyList(instance.states, '|') />
		
		<cfif refindnocase('^is(#stateList#)$', arguments.missingMethodName)>
			<cfreturn isInState(mid(arguments.missingMethodName, 3, len(arguments.missingMethodName)-2)) />		
		</cfif>
		
		<!--- Passthrough to decorated object --->
		<cfreturn invokeMethod(arguments.missingMethodName, arguments.missingMethodArguments) />
	</cffunction>

	
	<!--- Utility --->
	
	<cffunction name="invokeMethod" access="private" returntype="Any" output="false">
		<cfargument name="method" type="string" required="true" />
    <cfargument name="argcollection" type="struct" required="false" default="#structNew()#" />         

    <cfset var returnVar = "" />             

		<!--- runs cfinvoke on self to run an internal method ---> 
		<cfinvoke component="#getOriginalObject()#" method="#arguments.method#" argumentcollection="#arguments.argcollection#" returnvariable="returnVar" />
		
		<!--- returns the variables that cfinvoke work return --->
		<!--- will only return a variables if one is present --->
		<cfif isDefined("returnVar")>
			<cfreturn returnVar />
		</cfif>
	</cffunction>
	
	<cffunction name="dump" output="true" returntype="void">
		<cfargument name="v" type="any" required="true"/>
		<cfargument name="abort" type="boolean" default="false"/>
		<cfdump var="#arguments.v#"/>
		<cfif arguments.abort>
			<cfabort />
		</cfif>
	</cffunction>
	
</cfcomponent>
