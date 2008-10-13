<cfcomponent displayname="StateTransition" output="false">
	
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
		<cfargument name="persistenceObject" required="false" />
		<cfargument name="persistenceMethod" required="false" default="save" />
		
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
					// Set the state
					obj.setInternalState(getToState());
					// Do the update if we have an updater reference
					if(structKeyExists(arguments, 'persistenceObject') and isObject(arguments.persistenceObject)) {
						if(not persist(arguments.persistenceObject, arguments.persistenceMethod, obj)) {
							local.nextState.fail(obj);
							return false;
						}
					}
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

	<cffunction name="persist" access="private" returntype="boolean" output="false">
		<cfargument name="component" required="true" />
		<cfargument name="method" required="true" />
		<cfargument name="obj" required="true" />
		<cfinvoke component="#arguments.component#" method="#arguments.method#" returnvariable="success">
			<cfinvokeargument name="1" value="#arguments.obj#" />
		</cfinvoke>
		<!--- If the method returns void, assume it succeeded --->
		<cfparam name="success" default="true" type="boolean" />
		<cfreturn success />
	</cffunction>	
	
	
</cfcomponent>