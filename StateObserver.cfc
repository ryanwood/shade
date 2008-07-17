<cfcomponent name="target.StateObserver" hint="">

	<cfscript>
		instance = structNew();
	</cfscript>

	<!------------------------------------------- PUBLIC ------------------------------------------->

	<cffunction name="init" hint="Constructor" access="public" returntype="InjectorObserver" output="false">
		<cfargument name="timeService" type="clearcheck.utility.TimeService" required="true" />
		<cfargument name="eventManager" type="clearcheck.logging.EventManager" required="true" />
		<cfscript>
			setTimeService(arguments.timeService);
			setEventManager(arguments.eventManager);
			return this;
		</cfscript>
	</cffunction>

	<cffunction name="actionAfterNewTransferEvent" access="public" returntype="void" output="false">
    <cfargument name="event" type="transfer.com.events.TransferEvent" required="Yes">
		<cfscript>
			if( arguments.event.getTransferObject().getClassName() eq "security.Site" ) {
         arguments.event.getTransferObject().setEventManager(getEventManager());
			}

			//if( arguments.event.getTransferObject().getClassName() eq "portal.SubscriptionSetting" ) {
      //   arguments.event.getTransferObject().setTimeService(getTimeService());
			//}
		</cfscript>
	</cffunction>

	<!------------------------------------------- PACKAGE ------------------------------------------->

	<!------------------------------------------- PRIVATE ------------------------------------------->
	<cffunction name="getTimeService" access="private" returntype="clearcheck.utility.TimeService" output="false">
		<cfreturn instance.timeService />
	</cffunction>

	<cffunction name="setTimeService" access="private" returntype="void" output="false">
		<cfargument name="timeService" type="clearcheck.utility.TimeService" required="true" />
		<cfset instance.timeService = arguments.timeService />
	</cffunction>

	<cffunction name="getEventManager" access="private" returntype="clearcheck.logging.EventManager" output="false">
		<cfreturn instance.eventManager />
	</cffunction>

	<cffunction name="setEventManager" access="private" returntype="void" output="false">
		<cfargument name="EventManager" type="clearcheck.logging.EventManager" required="true" />
		<cfset instance.eventManager = arguments.eventManager />
	</cffunction>

</cfcomponent>