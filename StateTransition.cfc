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
		
			if(not guard(obj)) return false;
		
			local.isLoopback = obj.getCurrentState() eq getToState();
			local.states = arguments.obj.getStates();
			local.nextState = local.states[getToState()];
			local.oldState = local.states[obj.getCurrentState()];
			
			if(not local.isLoopback) { 
				local.nextState.entering(obj);	
			}
			
			obj.setState(getToState());
			
			if(not local.isLoopback) { 
				local.nextState.entered(obj);	
				local.oldState.exited(obj);	
			}
			
			return true;
   	</cfscript>
	</cffunction>	
	
	<cffunction name="isEqual" access="public" output="false">
		<cfargument name="obj" required="true" />
	</cffunction>
	
	
	<cffunction name="getFromState" access="public" returntype="string" output="false">
		<cfreturn instance.from />
	</cffunction>
	
	<cffunction name="getToState" access="public" returntype="string" output="false">
		<cfreturn instance.to />
	</cffunction>
	
	<cffunction name="setFromState" access="public" returntype="void" output="false">
		<cfargument name="From" type="string" required="true" />
		<cfset instance.from = arguments.from />
	</cffunction>
	
<!---
        class StateTransition
          attr_reader :from, :to, :opts
          
          def initialize(opts)
            @from, @to, @guard = opts[:from], opts[:to], opts[:guard]
            @opts = opts
          end
          
          def guard(obj)
            @guard ? obj.send(:run_transition_action, @guard) : true
          end

          def perform(record)
            return false unless guard(record)
            loopback = record.current_state == to
            states = record.class.read_inheritable_attribute(:states)
            next_state = states[to]
            old_state = states[record.current_state]
          
            next_state.entering(record) unless loopback
          
            record.update_attribute(record.class.state_column, to.to_s)
          
            next_state.entered(record) unless loopback
            old_state.exited(record) unless loopback
            true
          end
          
          def ==(obj)
            @from == obj.from && @to == obj.to
          end
        end
--->
	
</cfcomponent>