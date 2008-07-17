<cfcomponent displayname="StateMachineTest" extends="mxunit.framework.TestCase" output="false">

	<cffunction name="setup" returntype="void" access="public">
		<cfscript>
			conversation = createObject("component", "target.test.Conversation").init();
			conversationState = createObject( "component", "target.test.ConversationState" ).init(conversation);
		</cfscript>
	</cffunction>
	
	<cffunction name="testIsObject" returntype="void" access="public" output="false">
		<cfscript>
			assertTrue(isObject(conversationState));
		</cfscript>
	</cffunction>

	<cffunction name="testInitialStateValue" returntype="void" access="public" output="false">
		<cfscript>
			assertEquals('needsAttention', conversationState.getInitialState());
		</cfscript>
	</cffunction>
	
	<cffunction name="testStateColumnWasSet" returntype="void" access="public" output="false">
		<cfscript>
			assertEquals('MyState', conversationState.getStateMethod());
		</cfscript>
	</cffunction>
	
	<cffunction name="testInitialState" returntype="void" access="public" output="false">
		<cfscript>
			assertEquals('needsAttention', conversationState.getCurrentState());
		</cfscript>
	</cffunction>
	
	<cffunction name="testStatesWereSet" returntype="void" access="public" output="false">
		<cfscript>
			var statesToCheck = "needsAttention,read,closed,awaitingResponse,junk";
			var state = 0;
			var i = 0;
			var j = 0;
			var found = false;
			
			for(i = 1; i lte listLen(statesToCheck); i = i + 1) {
				state = listGetAt(statesToCheck, i);
				assertTrue(structKeyExists(conversationState.getStates(), state), "'#state#' was not found as an actual state.");
			}
		</cfscript>
	</cffunction>

	<cffunction name="testTransitionTable" returntype="void" access="public" output="false">
		<cfscript>
			var newMessageTransitions = structFind(conversationState.getTransitionTable(), 'newMessage');
			var i = 1;
			var expected_from = ['read', 'closed', 'awaitingResponse'];			
			var expected_to = 'needsAttention';
			
			assertEquals(3, newMessageTransitions.count());
			
			for(i = 1; i lte 3; i = i + 1) {
				assertEquals(expected_from[i], newMessageTransitions.getAt(i).getFromState());
				assertEquals(expected_to, newMessageTransitions.getAt(i).getToState());
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="testNextStateForEvent" returntype="void" access="public" output="false">
		<cfscript>
			//dump(conversationState.getNextStates())
			assertEquals('read', conversationState.getNextStateForEvent('view'));
		</cfscript>
	</cffunction>
	
	<cffunction name="testChangeState" returntype="void" access="public" output="false">
		<cfscript>
			conversationState.fireEvent('view');
			assertTrue(conversationState.isInState('read'));
		</cfscript>
	</cffunction>

	<cffunction name="testCanGoFromReadToClosedBecauseGuardPasses" returntype="void" access="public" output="false">
		<cfscript>
			conversationState.setCanClose(true);
			conversationState.fireEvent('view');
			conversationState.fireEvent('reply');
			conversationState.fireEvent('close');
			assertEquals('closed', conversationState.getCurrentState());
		</cfscript>
	</cffunction>
	
	<cffunction name="testCannotGoFromReadToClosedBecauseGuardPasses" returntype="void" access="public" output="false">
		<cfscript>
			conversationState.setCanClose(false);
			conversationState.fireEvent('view');
			conversationState.fireEvent('reply');
			conversationState.fireEvent('close');
			assertEquals('read', conversationState.getCurrentState());
		</cfscript>
	</cffunction>
	
	<cffunction name="testIgnoreInvalidEvents" returntype="void" access="public" output="false">
		<cfscript>
			conversationState.fireEvent('view');
			conversationState.fireEvent('junk');
			conversationState.fireEvent('someInvalidEvent');
			assertEquals('junk', conversationState.getCurrentState());
		</cfscript>
	</cffunction>	

	<cffunction name="testEntryActionExecuted" returntype="void" access="public" output="false">
		<cfscript>
			conversationState.setReadEnter(false);
			conversationState.fireEvent('view');
			assertTrue(conversationState.getReadEnter());
		</cfscript>
	</cffunction>	
	
	<!--- <cffunction name="testAfterActionsExecuted" returntype="void" access="public" output="false">
		<cfscript>
			conversationState.setReadAfterFirst(false);
			conversationState.setReadAfterSecond(false);
			conversationState.setClosedAfter(false);
			
			conversationState.fireEvent('view');
			
			assertTrue(conversationState.getReadAfterFirst());
			assertTrue(conversationState.getReadAfterSecond());
			
			assertTrue(conversationState.getCanClose());
			conversationState.fireEvent('close');
			
			assertTrue(conversationState.getClosedAfter());
		</cfscript>
	</cffunction>	 --->
	
	
	
	  def test_after_actions_executed
    c = Conversation.create

    c.read_after_first = false
    c.read_after_second = false
    c.closed_after = false

    c.view!
    assert c.read_after_first
    assert c.read_after_second

    c.can_close = true
    c.close!

    assert c.closed_after
    assert_equal :closed, c.current_state
  end

</cfcomponent>