<cfcomponent displayname="Conversation" output="false">	
	<cfset instance = structNew() />

	<cffunction name="init" access="public" returntype="any" output="false" hint="">
		<cfset instance.state = '' />
		<cfset instance.beforeActionCount = 0 />
		<cfreturn this />
	</cffunction>
		
	<cffunction name="getMyState" access="public" returntype="string" output="false">
		<cfreturn instance.state />
	</cffunction>
	
	<cffunction name="setMyState" access="public" returntype="void" output="false">
		<cfargument name="state" type="string" required="true" />
		<cfset instance.state = arguments.state />
	</cffunction>
	
	<!--- Properties for testing --->
	
	<cffunction name="getCanClose" access="public" returntype="string" output="false">
		<cfreturn instance.canClose />
	</cffunction>
	
	<cffunction name="setCanClose" access="public" returntype="void" output="false">
		<cfargument name="value" type="boolean" required="true" />
		<cfset instance.canClose = arguments.value />
	</cffunction>
	
	<cffunction name="getReadEnter" access="public" returntype="string" output="false">
		<cfreturn instance.readEnter />
	</cffunction>
	
	<cffunction name="setReadEnter" access="public" returntype="void" output="false">
		<cfargument name="value" type="boolean" required="true" />
		<cfset instance.readEnter = arguments.value />
	</cffunction>
		
	<cffunction name="getReadAfterFirstAction" access="public" returntype="string" output="false">
		<cfreturn instance.readAfterFirstAction />
	</cffunction>
	
	<cffunction name="setReadAfterFirstAction" access="public" returntype="void" output="false">
		<cfargument name="value" type="boolean" required="true" />
		<cfset instance.readAfterFirstAction = arguments.value />
	</cffunction>	
	
	<cffunction name="getReadAfterSecondAction" access="public" returntype="string" output="false">
		<cfreturn instance.readAfterSecondAction />
	</cffunction>
	
	<cffunction name="setReadAfterSecondAction" access="public" returntype="void" output="false">
		<cfargument name="value" type="boolean" required="true" />
		<cfset instance.readAfterSecondAction = arguments.value />
	</cffunction>	
	
	<cffunction name="getClosedAfter" access="public" returntype="string" output="false">
		<cfreturn instance.closedAfter />
	</cffunction>
	
	<cffunction name="setClosedAfter" access="public" returntype="void" output="false">
		<cfargument name="value" type="boolean" required="true" />
		<cfset instance.closedAfter = arguments.value />
	</cffunction>	
	
	<cffunction name="getNeedingAttentionEnter" access="public" returntype="string" output="false">
		<cfreturn instance.NeedingAttentionEnter />
	</cffunction>
	
	<cffunction name="setNeedingAttentionEnter" access="public" returntype="void" output="false">
		<cfargument name="value" type="boolean" required="true" />
		<cfset instance.NeedingAttentionEnter = arguments.value />
	</cffunction>	
	
	<cffunction name="getNeedingAttentionAfter" access="public" returntype="string" output="false">
		<cfreturn instance.NeedingAttentionAfter />
	</cffunction>
	
	<cffunction name="setNeedingAttentionAfter" access="public" returntype="void" output="false">
		<cfargument name="value" type="boolean" required="true" />
		<cfset instance.NeedingAttentionAfter = arguments.value />
	</cffunction>	
	
	<cffunction name="getReadExit" access="public" returntype="string" output="false">
		<cfreturn instance.readExit />
	</cffunction>
	
	<cffunction name="setReadExit" access="public" returntype="void" output="false">
		<cfargument name="value" type="boolean" required="true" />
		<cfset instance.readExit = arguments.value />
	</cffunction>	
	
	<cffunction name="incrementBeforeActionCount" access="public" returntype="void" output="false">
		<cfset instance.beforeActionCount = instance.beforeActionCount + 1 />
	</cffunction>	
	
	<cffunction name="getBeforeActionCount" access="public" returntype="Numeric" output="false">
		<cfreturn instance.beforeActionCount />
	</cffunction>	
	
	<cffunction name="getFailed" access="public" returntype="boolean" output="false">
		<cfreturn instance.Failed />
	</cffunction>
	
	<cffunction name="setFailed" access="public" returntype="void" output="false">
		<cfargument name="Failed" type="boolean" required="true" />
		<cfset instance.Failed = arguments.Failed />
	</cffunction>

	<cffunction name="getFailedForAwaitingResponse" access="public" returntype="boolean" output="false">
		<cfreturn instance.FailedForAwaitingResponse />
	</cffunction>
	
	<cffunction name="setFailedForAwaitingResponse" access="public" returntype="void" output="false">
		<cfargument name="FailedForAwaitingResponse" type="boolean" required="true" />
		<cfset instance.FailedForAwaitingResponse = arguments.FailedForAwaitingResponse />
	</cffunction>

</cfcomponent>