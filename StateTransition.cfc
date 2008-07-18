<cfcomponent displayname="Transition" output="false">
	
	<cfset instance = structNew() />
	
	<cffunction name="init" access="public" output="false">
		<cfargument name="from" type="string" required="true" />
		<cfargument name="to" type="string" required="true" />
		<cfargument name="guard" type="string" required="false" default="" />
		<cfscript>
			instance.from = arguments.from;
			instance.to = arguments.to;
			instance.guard = arguments.guard;
		</cfscript>			
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getMemento" access="public" output="false">
		<cfscript>
			var st = structNew();
			st.ToState = instance.to;
			st.FromState = instance.from;
			st.guard = instance.guard;
			return st;
		</cfscript>		
	</cffunction>
	
	<cffunction name="guard" returntype="boolean" access="public" output="false">
		<cfargument name="obj" required="true" />
		<cfset var result = true />
		<cfset var decorated = obj.getOriginalObject() />
		<cfif len(instance.guard) and structKeyExists(decorated, instance.guard)>
			<cfinvoke component="#decorated#" method="#instance.guard#" returnvariable="result" />
		</cfif>
		<cfreturn result />
	</cffunction>
	
	<cffunction name="perform" access="public" output="false">
		<cfargument name="obj" required="true" />
		<cfscript>
			var local = structNew();
		
			if(not guard(obj)) {
				return false;
			}
		
			local.isLoopback = obj.getCurrentState() eq getToState();
			local.states = arguments.obj.getStates();
			local.nextState = local.states[getToState()];
			local.oldState = local.states[obj.getCurrentState()];
			
			if(not local.isLoopback) {
				if(local.nextState.before(obj)) {	
					obj.setState(getToState());
					local.nextState.after(obj);	
					local.oldState.exit(obj);	
				} else {
				 return false;
				}
			}
			
			return true;
   	</cfscript>
	</cffunction>	
	
	<cffunction name="getFromState" access="public" returntype="string" output="false">
		<cfreturn instance.from />
	</cffunction>
	
	<cffunction name="getToState" access="public" returntype="string" output="false">
		<cfreturn instance.to />
	</cffunction>
	
</cfcomponent>