puts "creating roles"
admin_role      = Role.create(name:'admin',description:'site admin')
business_role   = Role.create(name:'business',description:'business development')
unassigned_role = Role.create(name:'unassigned',description:'unassigned')

puts "creating users"
unassigned = User.new
unassigned.email = 'unassigned@test.com'
unassigned.password = 'unassigned'
unassigned.role = unassigned_role
unassigned.approved = false
unassigned.first_name = "Unassigned"
unassigned.last_name = "Unassigned"
unassigned.save!

harry = User.new
harry.email = 'harry@test.com'
harry.password = 'password'
harry.role = admin_role
harry.approved = true
harry.first_name = "Harry"
harry.last_name = "Fairbanks"
harry.save!
user_array = [unassigned,harry]

(0...10).each do | i |
  user = User.new
  user.first_name = Faker::Name.first_name
  user.last_name = Faker::Name.last_name
  user.email = "#{user.first_name}_#{i}@test.com"
  user.password = 'password'
  if i.odd?
    user.role = admin_role
  else
    user.role = business_role
  end
  user.save!
  user_array << user
end


puts "creating request types"
bug     = RequestType.create(name:'Bug',description:'Software is broken.')
metric  = RequestType.create(name:'Metric',description:'New data is required.')
issue   = RequestType.create(name:'Issue',description:'Something needs to  be done.')
feature = RequestType.create(name:'Feature',description:'New code is required.')

puts "creating priorities"
low    = Priority.create(name:'Low',description:'Do when you can')
medium = Priority.create(name:'Medium',description:'Do before low')
high   = Priority.create(name:'High',description:'Do before medium')
urgent = Priority.create(name:'URGENT',description:'Do right now')

puts "creating statuses"
triage      = Status.create(name:'Triage',description:'Not defined yet.')
backlog     = Status.create(name:'Backlog',description:'Defined, but not assigned.')
assigned    = Status.create(name:'Assigned',description:'Assigned, but not worked on.')
in_progress = Status.create(name:'In Progress',description:'Being worked on.')
review      = Status.create(name:'In Review',description:'Needs to pass review')
completed   = Status.create(name:'Completed',description:'Completed and waiting on release')

puts "creating verticals"
all = Vertical.create(name:'All',description:'ALL Verticals')
tr  = Vertical.create(name:'TR',description:'therounds.com')
qid = Vertical.create(name:'QID',description:'qid.io')

vertical_array = [all,tr,qid]
request_type_array = [bug,metric,issue,feature]
priority_array = [low,medium,high,urgent]
status_array = [completed,review,in_progress, assigned, backlog, triage]

total_request_types = request_type_array.length
total_request_types = total_request_types -1
total_priorities = priority_array.length
total_priorities = total_priorities - 1
total_users = user_array.length
total_users = total_users - 1
total_verticals = vertical_array.length
total_verticals = total_verticals - 1
total_statuses = status_array.length
total_statuses = total_statuses - 1

puts "creating tasks"
  for iteration in 0..300
    Task.create( title: "#{Faker::Hipster.sentence}",
                 description: "#{Faker::ChuckNorris.fact}",
                 reported_by: user_array[(rand(0..total_users))],
                 assigned_to: user_array[(rand(0..total_users))],
                 request_type_id: request_type_array[(rand(0..total_request_types))].id,
                 member_facing: [true, false].sample,
                 vertical_id: vertical_array[(rand(0..total_verticals))].id,
                 required_by: (Date.today.next_day(rand(0..30))),
                 link: "#{Faker::Internet.url}",
                 priority_id: priority_array[(rand(0..total_priorities))].id,
                 status_id: status_array[(rand(0..total_statuses))].id
                )
  end
