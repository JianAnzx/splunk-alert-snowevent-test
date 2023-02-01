# terraform {
#   required_providers {
#     splunk = {
#       source  = "splunk/splunk"
#       version = "1.4.17"
#     }
#   }
# }

# terraform {
#  required_providers {
#    splunk = {
#    source = "local/providers/splunk"
#    version = "1.4.17"
#    }
#  }

# }

terraform {
  required_providers {
    splunk = {
      source  = "local/providers/splunk"
      version = "1.5.1"
    }
  }

}

provider "splunk" {
  url                  = "127.0.0.1:8089"
  username             = "admin"
  password             = "password01"
  insecure_skip_verify = true
}

resource "splunk_authorization_roles" "role01" {
  name           = "terraform-user01-role"
  default_app    = "search"
  imported_roles = ["power", "user"]
  capabilities   = ["accelerate_datamodel", "change_authentication", "restart_splunkd"]
}

resource "splunk_authentication_users" "user01" {
  name              = "user01"
  email             = "user01@example.com"
  password          = "password01"
  force_change_pass = false
  roles             = ["terraform-user01-role"]
  depends_on = [
    splunk_authorization_roles.role01
  ]
}


resource "splunk_indexes" "user01-index" {
  name                   = "user01-index"
  max_hot_buckets        = 0
  max_total_data_size_mb = 1000000
}

resource "splunk_global_http_event_collector" "http" {
  disabled   = false
  enable_ssl = true
  port       = 8088
}

resource "splunk_inputs_http_event_collector" "hec-token-01" {
  name       = "hec-token-01"
  index      = "user01-index"
  indexes    = ["user01-index", "history", "summary"]
  source     = "new:source"
  sourcetype = "new:sourcetype"
  disabled   = false
  use_ack    = 0
  acl {
    owner   = "user01"
    sharing = "global"
    read    = ["admin"]
    write   = ["admin"]
  }
  depends_on = [
    splunk_indexes.user01-index,
    splunk_authentication_users.user01,
    splunk_global_http_event_collector.http,
  ]
}


resource "splunk_saved_searches" "new-search-03" {
  actions                   = "email"
  action_email_format       = "table"
  action_email_max_time     = "5m"
  action_email_send_results = false
  action_email_subject      = "Splunk Alert: $name$"
  action_email_to           = "user01@splunk.com"
  action_email_track_alert  = true
  description               = "New search for user01"
  dispatch_earliest_time    = "rt-15m"
  dispatch_latest_time      = "rt-0m"
  cron_schedule             = "*/15 * * * *"
  name                      = "new-search-03"
  search                    = "index=* source=http:hec-token-01"


  alert_digest_mode     = true
  alert_expires         = "24h"
  alert_severity        = 4
  alert_suppress        = "0"
  alert_suppress_fields = ""
  alert_track           = false
  alert_comparator      = "greater than"
  alert_condition       = ""
  alert_threshold       = "10"
  alert_type            = "number of events"
  allow_skew            = "0"
  is_scheduled          = true
  is_visible            = true


  acl {
    app     = "search"
    owner   = "user01"
    sharing = "user"
  }
  depends_on = [
    splunk_authentication_users.user01,
    splunk_indexes.user01-index
  ]
}



resource "splunk_saved_searches" "new-search-04" {
  actions                               = "snow_event"
  action_snow_event_param_account       = "account-test"
  action_snow_event_param_node          = "node-test"
  action_snow_event_param_type          = "type-test"
  action_snow_event_param_resource      = "res-test"
  action_snow_event_param_severity      = 3
  action_snow_event_param_description   = "desc-test"
  action_snow_event_param_ci_identifier = "ci-test"
  action_snow_event_param_custom_fields = "cf-test"


  description            = "New search for user01"
  dispatch_earliest_time = "rt-15m"
  dispatch_latest_time   = "rt-0m"
  cron_schedule          = "*/15 * * * *"
  name                   = "new-search-04"
  search                 = "index=* source=http:hec-token-01"


  alert_digest_mode     = true
  alert_expires         = "24h"
  alert_severity        = 4
  alert_suppress        = "0"
  alert_suppress_fields = ""
  alert_track           = false
  alert_comparator      = "greater than"
  alert_condition       = ""
  alert_threshold       = "10"
  alert_type            = "number of events"
  allow_skew            = "0"
  is_scheduled          = true
  is_visible            = true


  acl {
    app     = "search"
    owner   = "user01"
    sharing = "app"
  }
  depends_on = [
    splunk_authentication_users.user01,
    splunk_indexes.user01-index
  ]
}



resource "splunk_saved_searches" "new-search-07" {
  actions                                 = "email, snow_event"
  action_snow_event_param_account         = "account-test"
  action_snow_event_param_node            = "node-test"
  action_snow_event_param_type            = "type-test"
  action_snow_event_param_resource        = "res-test"
  action_snow_event_param_severity        = 4
  action_snow_event_param_description     = "desc-test"
  action_snow_event_param_ci_identifier   = "ci-test"
  action_snow_event_param_custom_fields   = "cf-test"
  action_snow_event_param_additional_info = "additional info test"


  action_email_format       = "table"
  action_email_max_time     = "5m"
  action_email_send_results = false
  action_email_subject      = "Splunk Alert: $name$"
  action_email_to           = "user01@splunk.com"
  action_email_track_alert  = true



  description            = "New search for user01 05"
  dispatch_earliest_time = "rt-15m"
  dispatch_latest_time   = "rt-0m"
  cron_schedule          = "*/15 * * * *"
  name                   = "new-search-07"
  search                 = "index=* source=http:hec-token-01"


  alert_digest_mode     = true
  alert_expires         = "24h"
  alert_severity        = 4
  alert_suppress        = "0"
  alert_suppress_fields = ""
  alert_track           = false
  alert_comparator      = "greater than"
  alert_condition       = ""
  alert_threshold       = "10"
  alert_type            = "number of events"
  allow_skew            = "0"
  is_scheduled          = true
  is_visible            = true


  acl {
    app     = "search"
    owner   = "user01"
    sharing = "app"
  }
  depends_on = [
    splunk_authentication_users.user01,
    splunk_indexes.user01-index
  ]
}
