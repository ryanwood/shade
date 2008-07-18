<cfcomponent name="CollectionBase" hint="Collection of objects">
	
	<cfset instance = structNew() />
	
	<cffunction name="init" access="public" returntype="CollectionBase" output="false" hint="initiates instance of Collection">
		<cfset instance.container = arrayNew(1) />
		<cfset instance.index = 0 />		
		<cfreturn this />
	</cffunction>
	
	<!--- public methods --->
	<cffunction name="add" access="public" returntype="void" output="false" hint="adds new object to collection">
		<cfargument name="object" type="any" required="yes" />
		<cfset arrayAppend(instance.container, arguments.object) />
		<cfset instance.index = this.count() - 1 />
	</cffunction>
	
	<cffunction name="getAt" access="public" returntype="struct" output="false" hint="returns item at given index">
		<cfargument name="index" type="numeric" required="yes" hint="Collection (array) index that contains an object" />	
		<cfreturn instance.container[arguments.index] />
	</cffunction>
	
	<cffunction name="existsAt" access="public" returntype="boolean" output="false" hint="I check if item exists at a given position">
		<cfargument name="index" type="numeric" required="yes" hint="Collection (array) index that might contain an object" />
		<cfset var retVal = "" />
		<cfset var temp = "" />
		<cftry>
			<cfset temp = instance.container[arguments.index] />
			<cfset retVal = true />
			<cfcatch type="any">
				<cfset retVal = false />
			</cfcatch>
		</cftry>
		<cfreturn retVal />
	</cffunction>
	
	<cffunction name="removeAt" access="public" returntype="Boolean" output="false" hint="removes object at given index from collection">
		<cfargument name="index" type="Numeric" required="yes" hint="Collection (array) index that might contain an object" />
		<cfif arguments.index LTE this.count()>
			<cfset arrayDeleteAt(instance.container,arguments.index) />
			<cfreturn true />
		<cfelse>
			<cfreturn false />
		</cfif>
	</cffunction>
	
	<cffunction name="count" access="public" returntype="numeric" output="false" hint="returns number of objects in collection">
		<cfreturn arrayLen(instance.container) />
	</cffunction>
	
	<cffunction name="clear" access="public" returntype="void" output="false" hint="I reset the collection">
		<cfset instance.container = arrayNew(1) />
		<cfset instance.index = 1 />
	</cffunction>
	
	<!--- Iterator --->
	
	<cffunction name="next" access="public" output="false">
		<cfif hasNext()>
			<cfset instance.index = instance.index + 1 />
			<cfreturn instance.container[instance.index] />
		</cfif>
		<cfreturn '' />
	</cffunction>
	
	<cffunction name="hasNext" access="public" returntype="boolean" output="false">
		<cfreturn instance.index + 1 lte count() />
	</cffunction>
	
	<cffunction name="reset" access="public" output="false" returntype="void">
		<cfset instance.index = 0 />
	</cffunction>
	
</cfcomponent>