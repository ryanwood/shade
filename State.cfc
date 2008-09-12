<cfcomponent displayname="State" output="false">
	
	<cfset instance = structNew() />
	
	<cffunction name="init" access="public" output="false">
		<cfargument name="name" type="string" required="true" />
		<cfscript>
			instance.name = arguments.name;
		</cfscript>			
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getName" returntype="string" access="public" output="false">
		<cfreturn instance.name />
	</cffunction>
	
	<cffunction name="before" returntype="boolean" access="public" output="false">
		<cfargument name="obj" required="true" />
		<cfset invokeCallback('beforeAction', arguments.obj) />
		<cfreturn invokeCallback('before#getName()#Action', arguments.obj) />
	</cffunction>
	
	<cffunction name="after" returntype="void" access="public" output="false">
		<cfargument name="obj" required="true" />		
		<cfset invokeCallback('after#getName()#Action', arguments.obj) />
		<cfset invokeCallback('afterAction', arguments.obj) />
	</cffunction>	
	
	<cffunction name="exit" returntype="void" access="public" output="false">
		<cfargument name="obj" required="true" />
		<cfset invokeCallback('exit#getName()#Action', arguments.obj) />
		<cfset invokeCallback('exitAction', arguments.obj) />
	</cffunction>
	
	<cffunction name="invokeCallback" returntype="boolean" access="private" output="false">
		<cfargument name="callback" type="string" required="true" />
		<cfargument name="obj" required="true" />
		<cfif structKeyExists(arguments.obj, arguments.callback)>
			<cfinvoke component="#arguments.obj#" method="#arguments.callback#" returnvariable="result" />
			<cfif isDefined('result') and isBoolean(result)>
				<cfreturn result />
			</cfif> 
		</cfif>
		<cfreturn true />
	</cffunction>

</cfcomponent>