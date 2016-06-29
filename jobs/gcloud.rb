# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
require "http"

current_users = 0
supplier_app_last_users = 0
digital_marketplace_all_last_users = 0

SCHEDULER.every '2s' do
	last_users = current_users
	supplier_app_last_users = supplier_app_current_users
	digital_marketplace_all_last_users = dm_all_current_users

	gcloud_data = HTTP.headers(:accept => "application/json").get("https://spreadsheets.google.com/feeds/list/1wdFW-3fJYgQrtEdRx6EbiNMzNze3CVryhCnyHqXRJbA/od6/public/basic?alt=json")
	gcloud_data = gcloud_data.parse
	# g_cloud_framework_view = gcloud_data['feed']['entry'][0]['title']['$t']
	rt_users = gcloud_data['feed']['entry'][0]['content']['$t']
	rt_users = rt_users.delete "activeusers: "
	current_users = rt_users.to_i

	rt_supplier_app = gcloud_data['feed']['entry'][1]['content']['$t']
	rt_supplier_app = rt_supplier_app.delete "activeusers: "
	supplier_app_current_users = rt_supplier_app.to_i

	digital_marketplace_all = gcloud_data['feed']['entry'][2]['content']['$t']
	digital_marketplace_all = digital_marketplace_all.delete "activeusers"
	dm_all_current_users = digital_marketplace_all.to_i

	send_event('g_cloud_view', { current: current_users, last: last_users })
	send_event('g_cloud_framework_view', { current: supplier_app_current_users, last: supplier_app_last_users })
	send_event('dm_all_view', { current: dm_all_current_users, last: digital_marketplace_all_last_users })
end
