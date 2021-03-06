<cfcomponent displayname="StateMachineTest" extends="mxunit.framework.TestCase" output="false">

	<cffunction name="setup" returntype="void" access="public">
		<cfscript>
			service = createObject("component", "shade.test.ConversationService").init();
			conversation = service.new();
		</cfscript>
	</cffunction>
	
	<cffunction name="testIsObject" returntype="void" access="public" output="false">
		<cfscript>
			assertTrue(isObject(conversation));
		</cfscript>
	</cffunction>

	<cffunction name="testInitialStateValue" returntype="void" access="public" output="false">
		<cfscript>
			assertEquals('needingAttention', conversation.getInitialState());
		</cfscript>
	</cffunction>
	
	<cffunction name="testStateColumnWasSet" returntype="void" access="public" output="false">
		<cfscript>
			assertEquals('MyState', conversation.getStateMethod());
		</cfscript>
	</cffunction>
	
	<cffunction name="testInitialState" returntype="void" access="public" output="false">
		<cfscript>
			assertEquals('needingAttention', conversation.getCurrentState());
		</cfscript>
	</cffunction>
	
	<cffunction name="testStatesWereSet" returntype="void" access="public" output="false">
		<cfscript>
			var statesToCheck = "needingAttention,read,closed,awaitingResponse,junk";
			var state = 0;
			var i = 0;
			var j = 0;
			var found = false;
			
			for(i = 1; i lte listLen(statesToCheck); i = i + 1) {
				state = listGetAt(statesToCheck, i);
				assertTrue(structKeyExists(conversation.getStates(), state), "'#state#' was not found as an actual state.");
			}
		</cfscript>
	</cffunction>

	<cffunction name="testTransitionTable" returntype="void" access="public" output="false">
		<cfscript>
			var newMessageTransitions = structFind(conversation.getTransitionTable(), 'newMessage');
			var i = 1;
			var expected_from = ['read', 'closed', 'awaitingResponse'];			
			var expected_to = 'needingAttention';
			
			assertEquals(3, newMessageTransitions.count());
			
			for(i = 1; i lte 3; i = i + 1) {
				assertEquals(expected_from[i], newMessageTransitions.getAt(i).getFromState());
				assertEquals(expected_to, newMessageTransitions.getAt(i).getToState());
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="testNextStateForEvent" returntype="void" access="public" output="false">
		<cfscript>
			assertEquals('read', conversation.getNextStateForEvent('view'));
		</cfscript>
	</cffunction>
	
	<cffunction name="testChangeState" returntype="void" access="public" output="false">
		<cfscript>
			conversation.view();
			assertTrue(conversation.isInState('read'));
			assertTrue(conversation.isRead());			
		</cfscript>
	</cffunction>
	
	<cffunction name="testCanGoFromReadToClosedBecauseGuardPasses" returntype="void" access="public" output="false">
		<cfscript>
			conversation.setCanClose(true);
			conversation.fireEvent('view');
			conversation.fireEvent('reply');
			conversation.fireEvent('close');
			assertEquals('closed', conversation.getCurrentState());
		</cfscript>
	</cffunction>
	
	<cffunction name="testCannotGoFromReadToClosedBecauseGuardFails" returntype="void" access="public" output="false">
		<cfscript>
			conversation.setCanClose(false);
			conversation.fireEvent('view');
			conversation.fireEvent('reply');
			conversation.fireEvent('close');
			assertEquals('read', conversation.getCurrentState());
		</cfscript>
	</cffunction>
	
	<cffunction name="testIgnoreInvalidEvents" returntype="void" access="public" output="false">
		<cfscript>
			conversation.fireEvent('view');
			conversation.fireEvent('junk');
			conversation.fireEvent('someInvalidEvent');
			assertEquals('junk', conversation.getCurrentState());
		</cfscript>
	</cffunction>	

	<cffunction name="testEntryActionExecuted" returntype="void" access="public" output="false">
		<cfscript>
			conversation.setReadEnter(false);
			conversation.view();
			assertTrue(conversation.getReadEnter());
		</cfscript>
	</cffunction>	

	<cffunction name="testAfterActionsExecuted" returntype="void" access="public" output="false">
		<cfscript>
			conversation.setReadAfterFirstAction(false);
			conversation.setReadAfterSecondAction(false);
			conversation.setClosedAfter(false);
			
			conversation.view();
			
			assertTrue(conversation.getReadAfterFirstAction());
			assertTrue(conversation.getReadAfterSecondAction());
			
			conversation.setCanClose(true);
			conversation.close();

			assertTrue(conversation.getClosedAfter());
		</cfscript>
	</cffunction>
	
	<cffunction name="testAfterActionsNotRunOnLoopbackTransition" returntype="void" access="public" output="false">
		<cfscript>
			conversation.view();
			conversation.setReadAfterFirstAction(false);
			conversation.setReadAfterSecondAction(false);
			conversation.view();
			
			assertFalse(conversation.getReadAfterFirstAction());
			assertFalse(conversation.getReadAfterSecondAction());
			
			conversation.setCanClose(true);
			
			conversation.close();
			conversation.setClosedAfter(false);
			conversation.close();
			
			assertFalse(conversation.getClosedAfter());
		</cfscript>
	</cffunction>

	<cffunction name="testExitActionExecuted" returntype="void" access="public" output="false">
		<cfscript>
			conversation.setReadExit(false);
			conversation.view();
			conversation.junk();			
			assertTrue(conversation.getReadExit());
		</cfscript>
	</cffunction>
	
	<cffunction name="testEntryAndExitNotRunOnLoopbackTransition" returntype="void" access="public" output="false">
		<cfscript>
			conversation.view();
			conversation.setReadEnter(false);
			conversation.setReadExit(false);
			conversation.view();
			
			assertFalse(conversation.getReadEnter());
			assertFalse(conversation.getReadExit());
		</cfscript>
	</cffunction>
	
	<cffunction name="testEntryAndAfterActionsCalledForInitialState" returntype="void" access="public" output="false">
		<cfscript>
			assertTrue(conversation.getNeedingAttentionEnter());
			assertTrue(conversation.getNeedingAttentionAfter());
		</cfscript>
	</cffunction>
	
	<cffunction name="testCannotMakeAnInvalidTransition" returntype="void" access="public" output="false">
		<cfscript>
			// Try to junk a new message
			conversation.junk();
			assertFalse(conversation.isJunk());
			
			conversation.view();			
			assertTrue(conversation.isRead());
			
			conversation.junk();			
			assertTrue(conversation.isJunk());
		</cfscript>
	</cffunction>

	<cffunction name="testTransitionAbortedIfBeforeActionReturnsFalse" returntype="void" access="public" output="false">
		<cfscript>
			assertTrue(conversation.view());
			assertTrue(conversation.isRead());
			assertFalse(conversation.file());
			assertTrue(conversation.isRead());
		</cfscript>
	</cffunction>	
	
	<cffunction name="testEventReturnsTrueWhenTransitionIsSuccessful" returntype="void" access="public" output="false">
		<cfscript>
			assertFalse(conversation.junk());
			assertTrue(conversation.view());
		</cfscript>
	</cffunction>

	<cffunction name="testCannotSetStateDirectly" returntype="void" access="public" output="false">
		<cfscript>
			try {
				conversation.setMyState('new');
				fail('Should not be able to set state directly.');
			} catch( any e ) {
				assertEquals( 'shade.InvalidStateChange', e.type );
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="testGlobalBeforeActionExecuted" returntype="void" access="public" output="false">
		<cfscript>
			// Should be 1 because it has to set the initial state
			assertEquals(1, conversation.getBeforeActionCount());
			conversation.view();
			assertEquals(2, conversation.getBeforeActionCount());
			conversation.reply();
			assertEquals(3, conversation.getBeforeActionCount());
		</cfscript>
	</cffunction>

	<cffunction name="testRecordIsPersistedOnStateChange" returntype="void" access="public" output="false">
		<cfscript>
			assertFalse(service.recordSaved());
			conversation.view();
			assertTrue(service.recordSaved());
			assertTrue(conversation.isRead());			
		</cfscript>
	</cffunction>	
	
	<cffunction name="testAfterAndExitNotRunOnPersistenceFailed" returntype="void" access="public" output="false">
		<cfscript>
			service.setSaveShouldFail(true);			
			conversation.setReadAfterFirstAction(false);
			assertFalse(conversation.view());
			assertFalse(service.recordSaved());
			assertFalse(conversation.getReadAfterFirstAction());
		</cfscript>
	</cffunction>

	<cffunction name="testFailedActionExecuted" returntype="void" access="public" output="false">
		<cfscript>
			service.setSaveShouldFail(true);
			conversation.setFailed(false);			
			assertFalse(conversation.view());		
			assertTrue(conversation.getFailed());
		</cfscript>
	</cffunction>
		
</cfcomponent>