<cfcomponent displayname="Conversation" output="false">	
	<cfset instance = structNew() />

	<cffunction name="init" access="public" returntype="any" output="false" hint="">
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
		
	<cffunction name="getReadAfterFirst" access="public" returntype="string" output="false">
		<cfreturn instance.readAfterFirst />
	</cffunction>
	
	<cffunction name="setReadAfterFirst" access="public" returntype="void" output="false">
		<cfargument name="value" type="boolean" required="true" />
		<cfset instance.readAfterFirst = arguments.value />
	</cffunction>	
	
	<cffunction name="getReadAfterSecond" access="public" returntype="string" output="false">
		<cfreturn instance.readAfterSecond />
	</cffunction>
	
	<cffunction name="setReadAfterSecond" access="public" returntype="void" output="false">
		<cfargument name="value" type="boolean" required="true" />
		<cfset instance.readAfterSecond = arguments.value />
	</cffunction>	
	
	<cffunction name="getClosedAfter" access="public" returntype="string" output="false">
		<cfreturn instance.closedAfter />
	</cffunction>
	
	<cffunction name="setClosedAfter" access="public" returntype="void" output="false">
		<cfargument name="value" type="boolean" required="true" />
		<cfset instance.closedAfter = arguments.value />
	</cffunction>	

</cfcomponent>