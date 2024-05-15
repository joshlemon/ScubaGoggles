package drive

import data.utils
import future.keywords

LogEvents := utils.GetEvents("drive_logs")

###################
# GWS.DRIVEDOCS.1 #
###################

#
# Baseline GWS.DRIVEDOCS.1.1v0.1
#--
NonCompliantOUs1_1 contains OU if {
    some OU in utils.OUsWithEvents
    Events := utils.FilterEvents(LogEvents, "SHARING_OUTSIDE_DOMAIN", OU)
    count(Events) > 0
    LastEvent := utils.GetLastEvent(Events)
    AcceptableValues := {"SHARING_NOT_ALLOWED", "INHERIT_FROM_PARENT",
     "SHARING_NOT_ALLOWED_BUT_MAY_RECEIVE_FILES"}
    not LastEvent.NewValue in AcceptableValues
}

tests contains {
    "PolicyId": "GWS.DRIVEDOCS.1.1v0.1",
    "Criticality": "Should",
    "ReportDetails": utils.NoSuchEventDetails(DefaultSafe, utils.TopLevelOU),
    "ActualValue": "No relevant event for the top-level OU in the current logs",
    "RequirementMet": DefaultSafe,
    "NoSuchEvent": true
}
if {
    DefaultSafe := false
    Events := utils.FilterEvents(LogEvents, "SHARING_OUTSIDE_DOMAIN", utils.TopLevelOU)
    count(Events) == 0
}

tests contains {
    "PolicyId": "GWS.DRIVEDOCS.1.1v0.1",
    "Criticality": "Should",
    "ReportDetails": utils.ReportDetailsOUs(NonCompliantOUs1_1),
    "ActualValue": {"NonCompliantOUs": NonCompliantOUs1_1},
    "RequirementMet": Status,
    "NoSuchEvent": false
}
if {
    Events := utils.FilterEvents(LogEvents, "SHARING_OUTSIDE_DOMAIN", utils.TopLevelOU)
    count(Events) > 0
    Status := count(NonCompliantOUs1_1) == 0
}
#--

# Can be combined with 1.1, since this is a single setting with the same value that will pass for both conditions
#
# Baseline GWS.DRIVEDOCS.1.2v0.1
#--
NonCompliantOUs1_2 contains OU if {
    some OU in utils.OUsWithEvents
    Events := utils.FilterEvents(LogEvents, "SHARING_OUTSIDE_DOMAIN", OU)
    count(Events) > 0
    LastEvent := utils.GetLastEvent(Events)
    contains("SHARING_NOT_ALLOWED INHERIT_FROM_PARENT", LastEvent.NewValue) == false
}

tests contains {
    "PolicyId": "GWS.DRIVEDOCS.1.2v0.1",
    "Criticality": "Should",
    "ReportDetails": utils.NoSuchEventDetails(DefaultSafe, utils.TopLevelOU),
    "ActualValue": "No relevant event for the top-level OU in the current logs",
    "RequirementMet": DefaultSafe,
    "NoSuchEvent": true
}
if {
    DefaultSafe := false
    Events := utils.FilterEvents(LogEvents, "SHARING_OUTSIDE_DOMAIN", utils.TopLevelOU)
    count(Events) == 0
}

tests contains {
    "PolicyId": "GWS.DRIVEDOCS.1.2v0.1",
    "Criticality": "Should",
    "ReportDetails": utils.ReportDetailsOUs(NonCompliantOUs1_2),
    "ActualValue": {"NonCompliantOUs": NonCompliantOUs1_2},
    "RequirementMet": Status,
    "NoSuchEvent": false
}
if {
    Events := utils.FilterEvents(LogEvents, "SHARING_OUTSIDE_DOMAIN", utils.TopLevelOU)
    count(Events) > 0
    Status := count(NonCompliantOUs1_2) == 0
}
#--

# Can be combined with 1.4 since a single policy can be used to check both conditions
#
# Baseline GWS.DRIVEDOCS.1.3v0.1
#--
NonCompliantOUs1_3 contains OU if {
    some OU in utils.OUsWithEvents
    Events := utils.FilterEvents(LogEvents, "SHARING_OUTSIDE_DOMAIN", OU)
    count(Events) > 0
    LastEvent := utils.GetLastEvent(Events)
    AcceptableValues := {"SHARING_ALLOWED_WITH_WARNING", "SHARING_NOT_ALLOWED",
     "INHERIT_FROM_PARENT", "SHARING_NOT_ALLOWED_BUT_MAY_RECEIVE_FILES"}
    not LastEvent.NewValue in AcceptableValues
}

tests contains {
    "PolicyId": "GWS.DRIVEDOCS.1.3v0.1",
    "Criticality": "Shall",
    "ReportDetails": utils.NoSuchEventDetails(DefaultSafe, utils.TopLevelOU),
    "ActualValue": "No relevant event for the top-level OU in the current logs",
    "RequirementMet": DefaultSafe,
    "NoSuchEvent": true
}
if {
    DefaultSafe := false
    Events := utils.FilterEvents(LogEvents, "SHARING_OUTSIDE_DOMAIN", utils.TopLevelOU)
    count(Events) == 0
}

tests contains {
    "PolicyId": "GWS.DRIVEDOCS.1.3v0.1",
    "Criticality": "Shall",
    "ReportDetails": utils.ReportDetailsOUs(NonCompliantOUs1_3),
    "ActualValue": {"NonCompliantOUs": NonCompliantOUs1_3},
    "RequirementMet": Status,
    "NoSuchEvent": false
}
if {
    Events := utils.FilterEvents(LogEvents, "SHARING_OUTSIDE_DOMAIN", utils.TopLevelOU)
    count(Events) > 0
    Status := count(NonCompliantOUs1_3) == 0
}
#--

#
# Baseline GWS.DRIVEDOCS.1.4v0.1
#--
NoSuchEvent1_4(TopLevelOU) := true if {
    SettingName := "SHARING_INVITES_TO_NON_GOOGLE_ACCOUNTS"
    Events_A := utils.FilterEvents(LogEvents, SettingName, TopLevelOU)
    count(Events_A) == 0
}

NoSuchEvent1_4(TopLevelOU) := true if {
    SettingName := "SHARING_OUTSIDE_DOMAIN"
    Events_B := utils.FilterEvents(LogEvents, SettingName, TopLevelOU)
    count(Events_B) == 0
}

default NoSuchEvent1_4(_) := false

NonCompliantOUs1_4 contains OU if {
    some OU in utils.OUsWithEvents
    Events_A := utils.FilterEvents(LogEvents, "SHARING_INVITES_TO_NON_GOOGLE_ACCOUNTS", OU)
    count(Events_A) > 0
    LastEvent_A := utils.GetLastEvent(Events_A)

    Events_B := utils.FilterEvents(LogEvents, "SHARING_OUTSIDE_DOMAIN", OU)
    count(Events_B) > 0
    LastEvent_B := utils.GetLastEvent(Events_B)

    AcceptableValues_A := {"NOT_ALLOWED", "INHERIT_FROM_PARENT"}
    not LastEvent_A.NewValue in AcceptableValues_A
    AcceptableValues_B := {"SHARING_NOT_ALLOWED", "INHERIT_FROM_PARENT"}
    not LastEvent_B.NewValue in AcceptableValues_B
}

tests contains {
    "PolicyId": "GWS.DRIVEDOCS.1.4v0.1",
    "Criticality": "Shall",
    "ReportDetails": utils.NoSuchEventDetails(DefaultSafe, utils.TopLevelOU),
    "ActualValue": "No relevant event for the top-level OU in the current logs",
    "RequirementMet": DefaultSafe,
    "NoSuchEvent": true
}
if {
    DefaultSafe := false
    NoSuchEvent1_4(utils.TopLevelOU)
}

tests contains {
    "PolicyId": "GWS.DRIVEDOCS.1.4v0.1",
    "Criticality": "Shall",
    "ReportDetails": utils.ReportDetailsOUs(NonCompliantOUs1_4),
    "ActualValue": {"NonCompliantOUs": NonCompliantOUs1_4},
    "RequirementMet": Status,
    "NoSuchEvent": false
}
if {
    not NoSuchEvent1_4(utils.TopLevelOU)
    Status := count(NonCompliantOUs1_4) == 0
}
#--

#
# Baseline GWS.DRIVEDOCS.1.5v0.1
#--
NonCompliantOUs1_5 contains OU if {
    some OU in utils.OUsWithEvents
    Events := utils.FilterEvents(LogEvents, "PUBLISHING_TO_WEB", OU)
    count(Events) > 0
    LastEvent := utils.GetLastEvent(Events)
    contains("ALLOWED", LastEvent.NewValue) == true
}

tests contains {
    "PolicyId": "GWS.DRIVEDOCS.1.5v0.1",
    "Criticality": "Shall",
    "ReportDetails": utils.NoSuchEventDetails(DefaultSafe, utils.TopLevelOU),
    "ActualValue": "No relevant event for the top-level OU in the current logs",
    "RequirementMet": DefaultSafe,
    "NoSuchEvent": true
}
if {
    DefaultSafe := false
    Events := utils.FilterEvents(LogEvents, "PUBLISHING_TO_WEB", utils.TopLevelOU)
    count(Events) == 0
}

tests contains {
    "PolicyId": "GWS.DRIVEDOCS.1.5v0.1",
    "Criticality": "Shall",
    "ReportDetails": utils.ReportDetailsOUs(NonCompliantOUs1_5),
    "ActualValue": {"NonCompliantOUs": NonCompliantOUs1_5},
    "RequirementMet": Status,
    "NoSuchEvent": false
}
if {
    Events := utils.FilterEvents(LogEvents, "PUBLISHING_TO_WEB", utils.TopLevelOU)
    count(Events) > 0
    Status := count(NonCompliantOUs1_5) == 0
}
#--

#
# Baseline GWS.DRIVEDOCS.1.6v0.1
#--
NonCompliantOUs1_6 contains OU if {
    some OU in utils.OUsWithEvents
    Events := utils.FilterEvents(LogEvents, "SHARING_ACCESS_CHECKER_OPTIONS", OU)
    count(Events) > 0
    LastEvent := utils.GetLastEvent(Events)
    contains("NAMED_PARTIES_ONLY DOMAIN_OR_NAMED_PARTIES INHERIT_FROM_PARENT", LastEvent.NewValue) == false
}

tests contains {
    "PolicyId": "GWS.DRIVEDOCS.1.6v0.1",
    "Criticality": "Shall",
    "ReportDetails": utils.NoSuchEventDetails(DefaultSafe, utils.TopLevelOU),
    "ActualValue": "No relevant event for the top-level OU in the current logs",
    "RequirementMet": DefaultSafe,
    "NoSuchEvent": true
}
if {
    DefaultSafe := false
    Events := utils.FilterEvents(LogEvents, "SHARING_ACCESS_CHECKER_OPTIONS",utils.TopLevelOU)
    count(Events) == 0
}

tests contains {
    "PolicyId": "GWS.DRIVEDOCS.1.6v0.1",
    "Criticality": "Shall",
    "ReportDetails": utils.ReportDetailsOUs(NonCompliantOUs1_6),
    "ActualValue": {"NonCompliantOUs": NonCompliantOUs1_6},
    "RequirementMet": Status,
    "NoSuchEvent": false
}
if {
    Events := utils.FilterEvents(LogEvents, "SHARING_ACCESS_CHECKER_OPTIONS", utils.TopLevelOU)
    count(Events) > 0
    Status := count(NonCompliantOUs1_6) == 0
}
#--

#
# Baseline GWS.DRIVEDOCS.1.7v0.1
#--
NonCompliantOUs1_7 contains OU if {
    some OU in utils.OUsWithEvents
    Events := utils.FilterEvents(LogEvents, "SHARING_TEAM_DRIVE_CROSS_DOMAIN_OPTIONS", OU)
    count(Events) > 0
    LastEvent := utils.GetLastEvent(Events)
    SettingValue := "CROSS_DOMAIN_MOVES_BLOCKED INHERIT_FROM_PARENT"
    contains(SettingValue, LastEvent.NewValue) == false
}

tests contains {
    "PolicyId": "GWS.DRIVEDOCS.1.7v0.1",
    "Criticality": "Shall",
    "ReportDetails": utils.NoSuchEventDetails(DefaultSafe, utils.TopLevelOU),
    "ActualValue": "No relevant event for the top-level OU in the current logs",
    "RequirementMet": DefaultSafe,
    "NoSuchEvent": true
}
if {
    DefaultSafe := false
    Events := utils.FilterEvents(LogEvents, "SHARING_TEAM_DRIVE_CROSS_DOMAIN_OPTIONS", utils.TopLevelOU)
    count(Events) == 0
}

tests contains {
    "PolicyId": "GWS.DRIVEDOCS.1.7v0.1",
    "Criticality": "Shall",
    "ReportDetails": utils.ReportDetailsOUs(NonCompliantOUs1_7),
    "ActualValue": {"NonCompliantOUs": NonCompliantOUs1_7},
    "RequirementMet": Status,
    "NoSuchEvent": false
}
if {
    Events := utils.FilterEvents(LogEvents, "SHARING_TEAM_DRIVE_CROSS_DOMAIN_OPTIONS", utils.TopLevelOU)
    count(Events) > 0
    Status := count(NonCompliantOUs1_7) == 0
}
#--

#
# Baseline GWS.DRIVEDOCS.1.8v0.1
#--
NonCompliantOUs1_8 contains OU if {
    some OU in utils.OUsWithEvents
    Events := utils.FilterEvents(LogEvents, "DEFAULT_LINK_SHARING_FOR_NEW_DOCS", OU)
    count(Events) > 0
    LastEvent := utils.GetLastEvent(Events)
    LastEvent.NewValue != "PRIVATE"
    LastEvent.NewValue != "INHERIT_FROM_PARENT"
}

tests contains {
    "PolicyId": "GWS.DRIVEDOCS.1.8v0.1",
    "Criticality": "Shall",
    "ReportDetails": utils.NoSuchEventDetails(DefaultSafe, utils.TopLevelOU),
    "ActualValue": "No relevant event for the top-level OU in the current logs",
    "RequirementMet": DefaultSafe,
    "NoSuchEvent": true
}
if {
    DefaultSafe := false
    Events := utils.FilterEvents(LogEvents, "DEFAULT_LINK_SHARING_FOR_NEW_DOCS",utils.TopLevelOU)
    count(Events) == 0
}

tests contains {
    "PolicyId": "GWS.DRIVEDOCS.1.8v0.1",
    "Criticality": "Shall",
    "ReportDetails": utils.ReportDetailsOUs(NonCompliantOUs1_8),
    "ActualValue": {"NonCompliantOUs": NonCompliantOUs1_8},
    "RequirementMet": Status,
    "NoSuchEvent": false
}
if {
    Events := utils.FilterEvents(LogEvents, "DEFAULT_LINK_SHARING_FOR_NEW_DOCS", utils.TopLevelOU)
    count(Events) > 0
    Status := count(NonCompliantOUs1_8) == 0
}
#--

###################
# GWS.DRIVEDOCS.2 #
###################

#
# Baseline GWS.DRIVEDOCS.2.1v0.1
#--
NonCompliantOUs2_1 contains {
    "Name": OU, 
    "Value": "Members with manager access can override shared drive settings."
    } if {
    some OU in utils.OUsWithEvents
    Events := utils.FilterEventsOU(LogEvents, "Shared Drive Creation new_team_drive_admin_only", OU)
    count(Events) > 0
    LastEvent := utils.GetLastEvent(Events)
    contains("true", LastEvent.NewValue) == false
    LastEvent.NewValue != "DELETE_APPLICATION_SETTING"
}

NonCompliantGroups2_1 contains {
    "Name": Group,
    "Value": "Members with manager access can override shared drive settings."
    } if {
    some Group in utils.GroupsWithEvents
    Events := utils.FilterEventsGroup(LogEvents, "Shared Drive Creation new_team_drive_admin_only", Group)
    count(Events) > 0
    LastEvent := utils.GetLastEvent(Events)
    contains("true", LastEvent.NewValue) == false
    LastEvent.NewValue != "DELETE_APPLICATION_SETTING"
}

tests contains {
    "PolicyId": "GWS.DRIVEDOCS.2.1v0.1",
    "Criticality": "Should",
    "ReportDetails": utils.NoSuchEventDetails(DefaultSafe, utils.TopLevelOU),
    "ActualValue": "No relevant event for the top-level OU in the current logs",
    "RequirementMet": DefaultSafe,
    "NoSuchEvent": true
}
if {
    DefaultSafe := false
    Events := utils.FilterEventsOU(LogEvents, "Shared Drive Creation new_team_drive_admin_only", utils.TopLevelOU)
    count(Events) == 0
}

tests contains {
    "PolicyId": "GWS.DRIVEDOCS.2.1v0.1",
    "Criticality": "Should",
    "ReportDetails": utils.ReportDetails(NonCompliantOUs2_1, NonCompliantGroups2_1),
    "ActualValue": {"NonCompliantOUs": NonCompliantOUs2_1, "NonCompliantGroups": NonCompliantGroups2_1},
    "RequirementMet": Status,
    "NoSuchEvent": false
}
if {
    Events := utils.FilterEventsOU(LogEvents, "Shared Drive Creation new_team_drive_admin_only", utils.TopLevelOU)
    count(Events) > 0
    Conditions := {count(NonCompliantOUs2_1) == 0, count(NonCompliantGroups2_1) == 0 }
    Status := (false in Conditions) == false
}
#--

#
# Baseline GWS.DRIVEDOCS.2.2v0.1
#--
NonCompliantOUs2_2 contains {
    "Name": OU,
    "Value": "" 
    } if {
    some OU in utils.OUsWithEvents
    Events := utils.FilterEventsOU(LogEvents, "Shared Drive Creation new_team_drive_restricts_cross_domain_access", OU)
    count(Events) > 0
    LastEvent := utils.GetLastEvent(Events)
    contains("true", LastEvent.NewValue) == false
    LastEvent.NewValue != "DELETE_APPLICATION_SETTING"
}

NonCompliantGroups2_2 contains {
    "Name": Group,
    "Value": "" 
    } if {
    some Group in utils.GroupsWithEvents
    Events := utils.FilterEventsGroup(LogEvents, "Shared Drive Creation new_team_drive_restricts_cross_domain_access", Group)
    count(Events) > 0
    LastEvent := utils.GetLastEvent(Events)
    contains("true", LastEvent.NewValue) == false
    LastEvent.NewValue != "DELETE_APPLICATION_SETTING"
}

tests contains {
    "PolicyId": "GWS.DRIVEDOCS.2.2v0.1",
    "Criticality": "Should",
    "ReportDetails": utils.NoSuchEventDetails(DefaultSafe, utils.TopLevelOU),
    "ActualValue": "No relevant event for the top-level OU in the current logs",
    "RequirementMet": DefaultSafe,
    "NoSuchEvent": true
}
if {
    DefaultSafe := false
    SettingName := "Shared Drive Creation new_team_drive_restricts_cross_domain_access"
    Events := utils.FilterEventsOU(LogEvents, SettingName, utils.TopLevelOU)
    count(Events) == 0
}

tests contains {
    "PolicyId": "GWS.DRIVEDOCS.2.2v0.1",
    "Criticality": "Should",
    "ReportDetails": utils.ReportDetails(NonCompliantOUs2_2, NonCompliantGroups2_2),
    "ActualValue": {"NonCompliantOUs": NonCompliantOUs2_2, "NonCompliantGroups": NonCompliantGroups2_2},
    "RequirementMet": Status,
    "NoSuchEvent": false
}
if {
    SettingName := "Shared Drive Creation new_team_drive_restricts_cross_domain_access"
    Events := utils.FilterEvents(LogEvents, SettingName, utils.TopLevelOU)
    count(Events) > 0
    Conditions := {count(NonCompliantOUs2_2) == 0, count(NonCompliantGroups2_2) == 0 }
    Status := (false in Conditions) == false
}
#--

#
# Baseline GWS.DRIVEDOCS.2.3v0.1
#--
NonCompliantOUs2_3 contains {
    "Name": OU,
    "Value": ""
    } if {
    some OU in utils.OUsWithEvents
    Events := utils.FilterEventsOU(LogEvents, "Shared Drive Creation new_team_drive_restricts_direct_access", OU)
    count(Events) > 0
    LastEvent := utils.GetLastEvent(Events)
    contains("true", LastEvent.NewValue) == false
    LastEvent.NewValue != "DELETE_APPLICATION_SETTING"
}
NonCompliantGroups2_3 contains {
    "Name": Group,
    "Value": ""
    } if {
    some Group in utils.GroupsWithEvents
    Events := utils.FilterEventsGroup(LogEvents, "Shared Drive Creation new_team_drive_restricts_direct_access", Group)
    count(Events) > 0
    LastEvent := utils.GetLastEvent(Events)
    contains("true", LastEvent.NewValue) == false
    LastEvent.NewValue != "DELETE_APPLICATION_SETTING"
}


tests contains {
    "PolicyId": "GWS.DRIVEDOCS.2.3v0.1",
    "Criticality": "Shall",
    "ReportDetails": utils.NoSuchEventDetails(DefaultSafe, utils.TopLevelOU),
    "ActualValue": "No relevant event for the top-level OU in the current logs",
    "RequirementMet": DefaultSafe,
    "NoSuchEvent": true
}
if {
    DefaultSafe := false
    SettingName := "Shared Drive Creation new_team_drive_restricts_direct_access"
    Events := utils.FilterEventsOU(LogEvents, SettingName, utils.TopLevelOU)
    count(Events) == 0
}

tests contains {
    "PolicyId": "GWS.DRIVEDOCS.2.3v0.1",
    "Criticality": "Shall",
    "ReportDetails": utils.ReportDetails(NonCompliantOUs2_3, NonCompliantGroups2_3),
    "ActualValue": {"NonCompliantOUs": NonCompliantOUs2_3, "NonCompliantGroups": NonCompliantGroups2_3},
    "RequirementMet": Status,
    "NoSuchEvent": false
}
if {
    SettingName := "Shared Drive Creation new_team_drive_restricts_direct_access"
    Events := utils.FilterEventsOU(LogEvents, SettingName, utils.TopLevelOU)
    count(Events) > 0
     Conditions := {count(NonCompliantOUs2_3) == 0, count(NonCompliantGroups2_3) == 0 }
    Status := (false in Conditions) == false
}
#--

#
# Baseline GWS.DRIVEDOCS.2.4v0.1
#--
NonCompliantOUs2_4 contains {
    "Name": OU, 
    "Value": ""
    } if {
    some OU in utils.OUsWithEvents
    Events := utils.FilterEventsOU(LogEvents, "Shared Drive Creation new_team_drive_restricts_download", OU)
    count(Events) > 0
    LastEvent := utils.GetLastEvent(Events)
    contains("false", LastEvent.NewValue) == true
    LastEvent.NewValue != "DELETE_APPLICATION_SETTING"
}

NonCompliantGroups2_4 contains {
    "Name": Group, 
    "Value": ""
    } if {
    some Group in utils.GroupsWithEvents
    Events := utils.FilterEventsGroup(LogEvents, "Shared Drive Creation new_team_drive_restricts_download", Group)
    count(Events) > 0
    LastEvent := utils.GetLastEvent(Events)
    contains("false", LastEvent.NewValue) == true
    LastEvent.NewValue != "DELETE_APPLICATION_SETTING"
}

tests contains {
    "PolicyId": "GWS.DRIVEDOCS.2.4v0.1",
    "Criticality": "Shall",
    "ReportDetails": utils.NoSuchEventDetails(DefaultSafe, utils.TopLevelOU),
    "ActualValue": "No relevant event for the top-level OU in the current logs",
    "RequirementMet": DefaultSafe,
    "NoSuchEvent": true
}
if {
    DefaultSafe := false
    Events := utils.FilterEventsOU(LogEvents, "Shared Drive Creation new_team_drive_restricts_download", utils.TopLevelOU)
    count(Events) == 0
}

tests contains {
    "PolicyId": "GWS.DRIVEDOCS.2.4v0.1",
    "Criticality": "Shall",
    "ReportDetails": utils.ReportDetails(NonCompliantOUs2_4, NonCompliantGroups2_4),
    "ActualValue": {"NonCompliantOUs": NonCompliantOUs2_4, "NonCompliantGroups": NonCompliantGroups2_4},
    "RequirementMet": Status,
    "NoSuchEvent": false
}
if {
    Events := utils.FilterEventsOU(LogEvents, "Shared Drive Creation new_team_drive_restricts_download", utils.TopLevelOU)
    count(Events) > 0
     Conditions := {count(NonCompliantOUs2_4) == 0, count(NonCompliantGroups2_4) == 0 }
    Status := (false in Conditions) == false
}
#--


###################
# GWS.DRIVEDOCS.3 #
###################

#
# Baseline GWS.DRIVEDOCS.3.1v0.1
#--
NoSuchEvent3_1(TopLevelOU) := true if {
    # No such event...
    SettingName := "Link Security Update Settings allow_less_secure_link_user_restore"
    Events_A := utils.FilterEventsOU(LogEvents, SettingName, TopLevelOU)
    count(Events_A) == 0
}

NoSuchEvent3_1(TopLevelOU) := true if {
    # No such event...
    Events := utils.FilterEventsOU(LogEvents, "Link Security Update Settings less_secure_link_option", TopLevelOU)
    count(Events) == 0
}

default NoSuchEvent3_1(_) := false

GetFriendlyValue3_1(Value_B, Value_A) :=
"Remove security update from all impacted files" if {
    Value_B == "REQUIRE_LESS_SECURE_LINKS"
}
else := "Allow users to remove/apply the security update for files they own or manage" if {
    Value_A == "true"
}
NonCompliantOUs3_1 contains {
    "Name": OU, 
    "Value": concat("", [ GetFriendlyValue3_1(LastEvent_B.NewValue, LastEvent_A.NewValue)])
    } if {
    some OU in utils.OUsWithEvents
    Events_A := utils.FilterEventsOU(LogEvents, "Link Security Update Settings allow_less_secure_link_user_restore", OU)
    count(Events_A) > 0
    LastEvent_A := utils.GetLastEvent(Events_A)

    Events_B := utils.FilterEventsOU(LogEvents, "Link Security Update Settings less_secure_link_option", OU)
    count(Events_B) > 0
    LastEvent_B := utils.GetLastEvent(Events_B)

    true in {
        LastEvent_A.NewValue != "false",
        LastEvent_B.NewValue != "REMOVE_LESS_SECURE_LINKS"
    }
}

tests contains {
    "PolicyId": "GWS.DRIVEDOCS.3.1v0.1",
    "Criticality": "Shall",
    "ReportDetails": utils.NoSuchEventDetails(DefaultSafe, utils.TopLevelOU),
    "ActualValue": "No relevant event for the top-level OU in the current logs",
    "RequirementMet": DefaultSafe,
    "NoSuchEvent": true
}
if {
    DefaultSafe := false
    NoSuchEvent3_1(utils.TopLevelOU)
}

tests contains {
    "PolicyId": "GWS.DRIVEDOCS.3.1v0.1",
    "Criticality": "Shall",
    "ReportDetails": utils.ReportDetails(NonCompliantOUs3_1, []),
    "ActualValue" : {"NonCompliantOUs": NonCompliantOUs3_1},
    "RequirementMet": Status,
    "NoSuchEvent": false
}
if {
    not NoSuchEvent3_1(utils.TopLevelOU)
    Status := count(NonCompliantOUs3_1) == 0
}
#--

###################
# GWS.DRIVEDOCS.4 #
###################

#
# Baseline GWS.DRIVEDOCS.4.1v0.1
#--
NonCompliantOUs4_1 contains {
    "Name": OU,
    "Value": "Drive SDK is Enabled"
}
     if {
    some OU in utils.OUsWithEvents
    Events := utils.FilterEventsOU(LogEvents, "ENABLE_DRIVE_APPS", OU)
    count(Events) > 0
    LastEvent := utils.GetLastEvent(Events)
    LastEvent.NewValue != "false"
    LastEvent.NewValue != "INHERIT_FROM_PARENT"
}
NonCompliantGroups4_1 contains {
    "Name": Group,
    "Value": "Drive SDK is Enabled"
} if {
    some Group in utils.GroupsWithEvents
    Events := utils.FilterEventsGroup(LogEvents, "ENABLE_DRIVE_APPS", Group)
    count(Events) > 0
    LastEvent := utils.GetLastEvent(Events)
    LastEvent.NewValue != "false"
    LastEvent.NewValue != "INHERIT_FROM_PARENT"
}
tests contains {
    "PolicyId": "GWS.DRIVEDOCS.4.1v0.1",
    "Criticality": "Should",
    "ReportDetails": utils.NoSuchEventDetails(DefaultSafe, utils.TopLevelOU),
    "ActualValue": "No relevant event for the top-level OU in the current logs",
    "RequirementMet": DefaultSafe,
    "NoSuchEvent": true
}
if {
    DefaultSafe := false
    Events := utils.FilterEventsOU(LogEvents, "ENABLE_DRIVE_APPS", utils.TopLevelOU)
    count(Events) == 0

}

tests contains {
    "PolicyId": "GWS.DRIVEDOCS.4.1v0.1",
    "Criticality": "Should",
    "ReportDetails": utils.ReportDetails(NonCompliantOUs4_1, NonCompliantGroups4_1),
    "ActualValue": {"NonCompliantOUs": NonCompliantOUs4_1, "NonCompliantGroups": NonCompliantGroups4_1},
    "RequirementMet": Status,
    "NoSuchEvent": false
}
if {
    Events := utils.FilterEventsOU(LogEvents, "ENABLE_DRIVE_APPS", utils.TopLevelOU)
    count(Events) > 0
    Conditions := {count(NonCompliantOUs4_1) == 0, count(NonCompliantGroups4_1) == 0}
    Status := (false in Conditions) == false
}

#--


###################
# GWS.DRIVEDOCS.5 #
###################

#
# Baseline GWS.DRIVEDOCS.5.1v0.1
#--
NonCompliantOUs5_1 contains {
    "Name": OU, 
    "Value": "Users can install Google Docs add-ons from add-ons store."
    } if {
    some OU in utils.OUsWithEvents
    Events := utils.FilterEventsOU(LogEvents, "ENABLE_DOCS_ADD_ONS", OU)
    count(Events) > 0
    LastEvent := utils.GetLastEvent(Events)
    LastEvent.NewValue != "false"
    LastEvent.NewValue != "INHERIT_FROM_PARENT"
}

NonCompliantGroups5_1 contains {
    "Name": Group, 
    "Value": "Users can install Google Docs add-ons from add-ons store."
    } if {
    some Group in utils.GroupsWithEvents
    Events := utils.FilterEventsGroup(LogEvents, "ENABLE_DOCS_ADD_ONS", Group)
    count(Events) > 0
    LastEvent := utils.GetLastEvent(Events)
    LastEvent.NewValue != "false"
    LastEvent.NewValue != "INHERIT_FROM_PARENT"
}
tests contains {
    "PolicyId": "GWS.DRIVEDOCS.5.1v0.1",
    "Criticality": "Shall",
    "ReportDetails": utils.NoSuchEventDetails(DefaultSafe, utils.TopLevelOU),
    "ActualValue": "No relevant event for the top-level OU in the current logs",
    "RequirementMet": DefaultSafe,
    "NoSuchEvent": true
}
if {
    DefaultSafe := false
    Events := utils.FilterEventsOU(LogEvents, "ENABLE_DOCS_ADD_ONS", utils.TopLevelOU)
    count(Events) == 0

}

tests contains {
    "PolicyId": "GWS.DRIVEDOCS.5.1v0.1",
    "Criticality": "Shall",
    "ReportDetails": utils.ReportDetails(NonCompliantOUs5_1, NonCompliantGroups5_1),
    "ActualValue": {"NonCompliantOUs": NonCompliantOUs5_1, "NonCompliantGroups": NonCompliantGroups5_1},
    "RequirementMet": Status,
    "NoSuchEvent": false
}
if {
    Events := utils.FilterEventsOU(LogEvents, "ENABLE_DOCS_ADD_ONS", utils.TopLevelOU)
    count(Events) > 0
    Conditions := {count(NonCompliantOUs5_1) == 0, count(NonCompliantGroups5_1) == 0 }
    Status := (false in Conditions) == false
}
#--

###################
# GWS.DRIVEDOCS.6 #
###################

#
# Baseline GWS.DRIVEDOCS.6.1v0.1
#--
default NoSuchEvent6_1(_) := true

NoSuchEvent6_1(TopLevelOU) := false if {
    Events := utils.FilterEventsOU(LogEvents, "DriveFsSettingsProto drive_fs_enabled", TopLevelOU)
    count(Events) != 0
}

NoSuchEvent6_1(TopLevelOU) := false if {
    # No such event...
    Events := utils.FilterEventsOU(LogEvents, "DriveFsSettingsProto company_owned_only_enabled", TopLevelOU)
    count(Events) != 0
}

NonCompliantOUs6_1 contains {
    "Name": OU, 
    "Value": "Fail"
    } if {
    some OU in utils.OUsWithEvents
    Events_A := utils.FilterEventsOU(LogEvents, "DriveFsSettingsProto drive_fs_enabled", OU)
    count(Events_A) > 0
    LastEvent_A := utils.GetLastEvent(Events_A)
    LastEvent_A.NewValue != "DELETE_APPLICATION_SETTING"

    Events_B := utils.FilterEventsOU(LogEvents, "DriveFsSettingsProto company_owned_only_enabled", OU)
    count(Events_B) > 0
    LastEvent_B := utils.GetLastEvent(Events_B)
    LastEvent_B.NewValue != "DELETE_APPLICATION_SETTING"

    true in {
        LastEvent_A.NewValue != "true",
        LastEvent_B.NewValue != "true"
    }
}

NonCompliantGroups6_1 contains {
    "Name": Group, 
    "Value": ""
    } if {
    some Group in utils.GroupsWithEvents
    Events_A := utils.FilterEventsGroup(LogEvents, "DriveFsSettingsProto drive_fs_enabled", Group)
    count(Events_A) > 0
    LastEvent_A := utils.GetLastEvent(Events_A)
    LastEvent_A.NewValue != "DELETE_APPLICATION_SETTING"

    Events_B := utils.FilterEventsGroup(LogEvents, "DriveFsSettingsProto company_owned_only_enabled", Group)
    count(Events_B) > 0
    LastEvent_B := utils.GetLastEvent(Events_B)
    LastEvent_B.NewValue != "DELETE_APPLICATION_SETTING"

    true in {
        LastEvent_A.NewValue != "true",
        LastEvent_B.NewValue != "true"
    }
}

tests contains {
    "PolicyId": "GWS.DRIVEDOCS.6.1v0.1",
    "Criticality": "Should",
    "ReportDetails": utils.NoSuchEventDetails(DefaultSafe, utils.TopLevelOU),
    "ActualValue": "No relevant event for the top-level OU in the current logs",
    "RequirementMet": DefaultSafe,
    "NoSuchEvent": true
}
if {
    DefaultSafe := false
    NoSuchEvent6_1(utils.TopLevelOU)
}

tests contains {
    "PolicyId": "GWS.DRIVEDOCS.6.1v0.1",
    "Criticality": "Should",
    "ReportDetails": utils.ReportDetails(NonCompliantOUs6_1, NonCompliantGroups6_1),
    "ActualValue" : {"NonCompliantOUs": NonCompliantOUs6_1, "NonCompliantGroups": NonCompliantGroups6_1},
    "RequirementMet": Status,
    "NoSuchEvent": false
}
if {
    not NoSuchEvent6_1(utils.TopLevelOU)
    Conditions := {count(NonCompliantOUs6_1) == 0, count(NonCompliantGroups6_1) == 0}
    Status := (false in Conditions) == false
}
#--

###################
# GWS.DRIVEDOCS.7 #
###################

#
# Baseline GWS.DRIVEDOCS.7.1v0.1
#--
# not implementable: Need a way to see when a rule is created.
# The fact that a rule is created gets logged but the rule's
# contents are not.
tests contains {
    "PolicyId": "GWS.DRIVEDOCS.7.1v0.1",
    "Criticality": "Should/Not-Implemented",
    "ReportDetails": "Currently not able to be tested automatically; please manually check.",
    "ActualValue": "",
    "RequirementMet": false,
    "NoSuchEvent": true
}
#--