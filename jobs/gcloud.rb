# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
require "http"

current_users = 0

SCHEDULER.every '2s' do
	last_users = current_users
	gcloud_data = HTTP.get("https://spreadsheets.google.com/feeds/list/1wdFW-3fJYgQrtEdRx6EbiNMzNze3CVryhCnyHqXRJbA/od6/public/basic?alt=json")
	gcloud_data = gcloud_data.parse
	# g_cloud_framework_view = gcloud_data['feed']['entry'][0]['title']['$t']
	rt_users = gcloud_data['feed']['entry'][0]['content']['$t']
	rt_users = rt_users.delete "activeusers: "
	current_users = rt_users.to_i
	
	send_event('g_cloud_view', { current: current_users, last: last_users })
end
