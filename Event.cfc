<cfcomponent displayname="Event" output="false">
	
	<cfset instance = structNew() />
	
	<cffunction name="init" access="public" output="false">
		<cfargument name="name" type="string" required="true" />
		<cfargument name="transitionTable" type="struct" required="true" />
		<cfscript>
			instance.name = arguments.name;
			arguments.transitionTable[arguments.name] = createObject("component", "shade.StateTransitionCollection").init();
			instance.transitions = arguments.transitionTable[arguments.name];
		</cfscript>			
		<cfreturn this />
	</cffunction>
	
	<cffunction name="addTransitions" access="public" output="false">
		<cfargument name="from" type="string" required="true" />
		<cfargument name="to" type="string" required="true" />
		<cfargument name="guard" type="string" required="false" default="" />
		<cfset var local = structNew() />
		 
		<cfloop list="#arguments.from#" index="local.from">
			<cfset local.transition = createObject("component", "shade.StateTransition").init(local.from, arguments.to, arguments.guard) />
			<cfset instance.transitions.add(local.transition) />
		</cfloop>
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="fire" access="public" output="false">
		<cfargument name="obj" type="any" required="true" />
		<cfset var i = 1 />
		<cfset var transitions = instance.transitions.getTransitionsFromState(arguments.obj.getCurrentState()) />
		<cfset transition = 0 />

		<cfset transitions.reset() />
		<cfloop condition="transitions.hasNext()">
			<cfset transition = transitions.next() />
			<cfif transition.perform(obj)>
				<cfreturn true />
			</cfif>
		</cfloop>	
		<cfreturn false />	
	</cffunction>	
		
	<cffunction name="getName" access="public" returntype="string" output="false">
		<cfreturn instance.name />
	</cffunction>
	
	<cffunction name="getTransitions" access="public" returntype="string" output="false">
		<cfreturn instance.name />
	</cffunction>
	
</cfcomponent>