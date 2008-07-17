<cfcomponent output="false">
	
	<cfset instance = structNew() />
	
	<cffunction name="init" access="public" output="false">
		<cfargument name="stateObject" required="true" />
		<cfargument name="initialState" type="string" required="true" />
		<cfargument name="stateMethod" type="string" required="false" default="state" />
		<cfscript>
			setStateObject(arguments.stateObject);
			instance.states = structNew();
			instance.transitionTable = structNew();
			instance.eventTable = structNew();
			instance.stateMethod = arguments.stateMethod;			
			instance.initialState = arguments.initialState;
						
			configure();
			setState(instance.initialState);
						
			return this;
		</cfscript>
	</cffunction>
	
	<!--- Builds the state and event from the configuration --->
	
	<cffunction name="addState" access="private" output="false">
		<cfargument name="name" type="string" required="true" />
		<cfset var state = createObject("component", "target.State").init(arguments.name) />
		<cfset instance.states[arguments.name] = state />
		<cfreturn state />
	</cffunction>
	
	<cffunction name="addEvent" access="private" output="false">
		<cfargument name="name" type="string" required="true" />
		<cfset var event = createObject("component", "target.Event").init(arguments.name, instance.transitionTable) />
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
	
	<cffunction name="getStateObject" access="public" output="false">
		<cfreturn instance.stateObject />
	</cffunction>
	
	<cffunction name="setStateObject" access="public" output="false">
		<cfargument name="object" required="true" />	
		<cfset instance.stateObject = arguments.object />
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
	
	<!--- Some method twisting --->
	
	<cffunction name="onMissingMethod" output="false" access="public">
    <cfargument name="missingMethodName" type="string" />
    <cfargument name="missingMethodArguments" type="struct" />
		
		<!--- 
		Shortcut to wire up event methods, so basically if you have a 
		'trash' event, you can call obj.trash rather than the longer fireEvent(event) --->
		<cfif structKeyExists(instance.eventTable, arguments.missingMethodName)>
			<cfreturn fireEvent(arguments.missingMethodName) />		
		</cfif>
		
		<!--- Passthrough to decorated object --->
		<cfreturn invokeMethod(arguments.missingMethodName, arguments.missingMethodArguments) />
	</cffunction>

	
	<!--- Utility --->
	
	<cffunction name="invokeMethod" access="public" returntype="Any" output="false">
		<cfargument name="method" type="string" required="true" />
    <cfargument name="argcollection" type="struct" required="false" default="#structNew()#" />         

    <cfset var returnVar = "" />             

		<!--- runs cfinvoke on self to run an internal method ---> 
		<cfinvoke component="#getStateObject()#" method="#arguments.method#" argumentcollection="#arguments.argcollection#" returnvariable="returnVar" />
		
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