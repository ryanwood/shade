<cfinterface displayname="target.IStateObserver">

	<cffunction name="actionOnEnteringState" access="public" returntype="void" output="false">
    <cfargument name="obj" type="target.StateMachine" required="true" />
	</cffunction>
	
	<cffunction name="actionOnEnteredState" access="public" returntype="void" output="false">
    <cfargument name="obj" type="target.StateMachine" required="true" />
	</cffunction>
	
	<cffunction name="actionOnExitingState" access="public" returntype="void" output="false">
    <cfargument name="obj" type="target.StateMachine" required="true" />
	</cffunction>

</cfinterface>