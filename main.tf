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
  #url = "192.168.150.228:8089"
  url = "anzx.splunkcloud.com:8089"
}


resource "splunk_saved_searches" "token-test12" {
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
  name                      = "token-test12"
  search                    = "index=*"


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
    app     = "anzx_spl_aegis_production"
    owner   = "e2etest"
    sharing = "app"
  }
}
