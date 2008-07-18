<cfcomponent displayname="StateTransitionCollection" extends="shade.CollectionBase" output="false">
	
	<cffunction name="init" access="public" output="false">
		<cfset super.init() />			
		<cfreturn this />
	</cffunction>

	<cffunction name="getMemento" access="public" output="false">
		<cfset var a = arrayNew(1) />
		<cfset reset() />
		<cfloop condition="hasNext()">
			<cfset arrayAppend(a, next().getMemento()) />
		</cfloop>
		<cfreturn a />
	</cffunction>


	<cffunction name="getTransitionsFromState" access="public" output="false">
		<cfargument name="state" type="string" required="true" />
		<cfset var i = 1 />
		<cfset var fromState = createObject("component", "shade.StateTransitionCollection").init() />
		<cfset var transition = "" />
		
		<cfset reset() />
		<cfloop condition="hasNext()">
			<cfset transition = next() />
			<cfif transition.getFromState() eq arguments.state>
				<cfset fromState.add(transition) />
			</cfif>
		</cfloop>
		<cfreturn fromState />
	</cffunction>

</cfcomponent>