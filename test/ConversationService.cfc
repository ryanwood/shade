<cfcomponent output="false">
	<cfset instance = structNew() />
	
	<cffunction name="init" access="public" returntype="any" output="false">
		<cfset instance.saved = false />
		<cfset instance.saveShouldFail = false />
		<cfreturn this />
	</cffunction>

	<cffunction name="new" access="public" returntype="shade.test.ConversationState" output="false">
		<cfset conversation = createObject("component", "shade.test.Conversation").init() />
		<cfreturn createObject( "component", "shade.test.ConversationState" ).init(conversation, this) />
	</cffunction>
		
	<cffunction name="save" access="public" returntype="boolean" output="false">
		<cfargument name="conversation" type="shade.test.ConversationState" required="true" />
		<cfif getSaveShouldFail()>
			<cfset instance.saved = false />
			<cfreturn false />
		<cfelse>
			<cfset instance.saved = true />
			<cfreturn true />
		</cfif>
	</cffunction>

	<cffunction name="recordSaved" access="public" returntype="boolean" output="false">
		<cfreturn instance.saved />		
	</cffunction>	

	<cffunction name="setSaveShouldFail" access="public" returntype="void" output="false">
		<cfargument name="value" type="boolean" required="true" />
		<cfset instance.saveShouldFail = arguments.value />
	</cffunction>
	
	<cffunction name="getSaveShouldFail" access="public" returntype="boolean" output="false">
		<cfreturn instance.saveShouldFail />
	</cffunction>
</cfcomponent>