require File.expand_path(File.dirname(__FILE__) + "/../../config/environment")

namespace :db do
	
	desc "Insert admin"
	task(:insert_admin => :environment) do		
		insert_user('admin', '@dm1n', true)
	end	
	
	desc "Insert user"
	task :insert_user, :user_name, :password, :admin, :needs => :environment  do |t, args| 
		user_name = args[:user_name]
		password = args[:password]
		admin = !args[:admin].nil?
		insert_user(user_name ||= "test",password ||= user_name, admin)
	end	
	
	task :insert_test_data => :environment do
		insert_user('admin', '@dm1n', true)
		(20..30).rand.times{|i| insert_user("user#{i}","user#{i}",false)}
		users = User.all
		(20..30).rand.times{|i| insert_topic(users)}
		
	end	
	
	class Range
		def rand
			 first + Kernel.rand(last-first+1)		
		end		
	end	
	
	
	def insert_topic(users)
		title = fake_data[0, (20..30).rand].join(' ').downcase.capitalize
		content = fake_data[0, (30..100).rand].join(' ').downcase
		topic = Topic.new(:title => title, :content => content)
		topic.user = random_user(users);
		topic.save
		p "Topic #{topic.id} was inserted"
		
		(11..30).rand.times{topic.posts << create_post(random_user(users) )}
		puts ''						
	end
	
	def create_post(user)
		content = fake_data[0, (30..100).rand].join(' ').downcase
		post = Post.new(:content => content, :user => user)
		print "."
		post		
	end
	
	def random_user(users)
		users.sort_by{rand}[0]		
	end
	def insert_user(user_name, password, admin)
		begin
			p "Add user #{user_name}"
			user = User.create(:login => user_name, :email => "#{user_name}.email@email.com", :password_confirmation => password, :password => password)
			user.admin = admin
			user.save!
			p "User #{user_name} was inserted!!!"
		rescue
			p "User with name: #{user_name} already exists"		
		end					
	end
	
	def fake_data
		text = %[
		You ve read the tutorials and watched the online videos. You have a strong grasp of all of the ingredients that make up a successful Rails application. But ingredients don t just turn themselves into a meal. Chad Fowler s Rails Recipes is a collection of recipes that will take you step by step through the the most cutting edge Rails techniques, mixing the ingredients to create world-class web applications. Learn how to do it, and how to do it right.
		Rails is large, powerful, and new. How do you use it effectively? How do you harness the power? And, most important, how do you get high-quality, real-world applications written?

		From the latest Ajax effects to time-saving automation tips for your development process, Rails Recipes will show you how the experts have already solved the problems you have.
		Before continuing, check to see that c:\ruby\bin is in your PATH by typing path at a command prompt. This will ensure that you can run ruby.exe from anywhere (which you'll need to run from your project root). If for some reason it's not there, you'll need to add it (how this is done can vary depending on which Windows Version you are running). 
		Out of the box, Rails uses the SQLite3 adapter and creates the DB in the db directory. If you look at your database.yml file (in \config), you'll see a database entry for your development, test, and production databases. Each should look something like this: 
		This means in development mode Rails is using the sqlite3 adapter to communicate with the database at db\development.sqlite3. This is fine during development, but in production, you'll probably want something beefier. You can change any of the entries to read from a different database type. Here's what an example MySQL entry would look like: 	
		]				
		text.split(' ').sort_by{rand}	
	end
	
end	