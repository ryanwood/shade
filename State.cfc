<cfcomponent displayname="State" output="false">
	<cfscript> instance = structNew(); </cfscript>
	
	<cffunction name="init" access="public" output="false">
		<cfargument name="name" type="string" required="true" />
		<cfscript>
			instance.name = arguments.name;
			instance.callbacks = structNew();
		</cfscript>			
		<cfreturn this />
	</cffunction>
	
	<!--- Set up chainable callback handlers --->
	
	<cffunction name="setEnterCallback" access="public" output="false">
		<cfargument name="method" type="string" required="true" />			
		<cfset instance.callbacks.enter = arguments.method />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setAfterCallback" access="public" output="false">
		<cfargument name="method" type="string" required="true" />			
		<cfset instance.callbacks.after = arguments.method />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setExitCallback" access="public" output="false">
		<cfargument name="method" type="string" required="true" />			
		<cfset instance.callbacks.exit = arguments.method />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getName" returntype="string" access="public" output="false">
		<cfreturn instance.name />
	</cffunction>
	
	<cffunction name="entering" returntype="void" access="public" output="false">
		<cfargument name="obj" required="true" />
		<cfset invokeCallback('#getName()#EnteringAction', arguments.obj) />
	</cffunction>
	
	<cffunction name="entered" returntype="void" access="public" output="false">
		<cfargument name="obj" required="true" />
		<cfset invokeCallback('after', arguments.obj) />
	</cffunction>	
	
	<cffunction name="exited" returntype="void" access="public" output="false">
		<cfargument name="obj" required="true" />
		<cfset invokeCallback('exit', arguments.obj) />
	</cffunction>
	
	<cffunction name="invokeCallback" returntype="void" access="public" output="false">
		<cfargument name="callback" type="string" required="true" />
		<cfargument name="obj" required="true" />		
		<cfif structKeyExists(arguments.obj, arguments.callback)>
			<cfinvoke component="#arguments.obj#" method="#arguments.callback#" />
		</cfif>
	</cffunction>

</cfcomponent>