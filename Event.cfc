<cfcomponent displayname="Event" output="false">
	
	<cfset instance = structNew() />
	
	<cffunction name="init" access="public" output="false">
		<cfargument name="name" type="string" required="true" />
		<cfargument name="transitionTable" type="struct" required="true" />
		<cfscript>
			instance.name = arguments.name;
			// Use an ArrayList rather than a normal array so it will be passed by reference, not value
			arguments.transitionTable[arguments.name] = createObject("component", "target.StateTransitionCollection").init();
			instance.transitions = arguments.transitionTable[arguments.name];
		</cfscript>			
		<cfreturn this />
	</cffunction>
	
	<cffunction name="addTransitions" access="public" output="false">
		<cfargument name="from" type="string" required="true" />
		<cfargument name="to" type="string" required="true" />
		<cfargument name="guard" type="string" required="false" default="" />
		<cfset var local = structNew() />
		 
		<cfloop list="#arguments.from#" index="local.from">
			<cfset local.transition = createObject("component", "target.StateTransition").init(local.from, arguments.to, arguments.guard) />
			<cfset instance.transitions.add(local.transition) />
		</cfloop>
		
		<cfreturn this />
	</cffunction>
	
	<!--- <cffunction name="getNextStates" access="public" output="false">
		<cfargument name="obj" required="true" />
		<cfset var i = 1 />
		<cfset var next = arrayNew(1) />
		<cfset var transition = "" />
		
		<cfset instance.transitions.reset() />		
		<cfloop condition="instance.transitions.hasNext()">
			<cfset transition = instance.transitions.next() />
			<cfif transition.getFromState() eq obj.getCurrentState()>
				<cfset arrayAppend(next, transition) />
			</cfif>
		</cfloop>
		<cfreturn next />
	</cffunction> --->
	
	<cffunction name="fire" access="public" output="false">
		<cfargument name="obj" type="any" required="true" />
		<cfset var i = 1 />
		<cfset var transitions = instance.transitions.getTransitionsFromState(arguments.obj.getCurrentState()) />
		<cfset transition = 0 />

		<cfset transitions.reset() />
		<cfloop condition="transitions.hasNext()">
			<cfset transition = transitions.next() />
			<cfif transition.perform(obj)>
				<cfbreak />
			</cfif>
		</cfloop>		
	</cffunction>	
	
	<cffunction name="transitions" access="public" output="false">
		<cfargument name="record" required="true" />
	</cffunction>
	
	
	<cffunction name="getName" access="public" returntype="string" output="false">
		<cfreturn instance.name />
	</cffunction>
	
	<cffunction name="getTransitions" access="public" returntype="string" output="false">
		<cfreturn instance.name />
	</cffunction>

<!---
        class Event
          attr_reader :name
          attr_reader :transitions
          attr_reader :opts

          def initialize(name, opts, transition_table, &block)
            @name = name.to_sym
            @transitions = transition_table[@name] = []
            instance_eval(&block) if block
            @opts = opts
            @opts.freeze
            @transitions.freeze
            freeze
          end
          
          def next_states(record)
            @transitions.select { |t| t.from == record.current_state }
          end
          
          def fire(record)
            next_states(record).each do |transition|
              break true if transition.perform(record)
            end
          end
          
          def transitions(trans_opts)
            Array(trans_opts[:from]).each do |s|
              @transitions << SupportingClasses::StateTransition.new(trans_opts.merge({:from => s.to_sym}))
            end
          end
        end
      end
--->
	
</cfcomponent>