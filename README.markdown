Sum
===

A budgeting app built on Sinatra. Use it at [sumapp.com](http://sumapp.com).

Compatibility
-------------

Sum is actively maintained under Ruby 1.9.1.

The flow
--------

Fill out a form containing your total monthly bills, income, and desired savings. When you use your credit card or the ATM, send an email to [sum@sumapp.com](mailto:sum@sumapp.com) with the dollar amount. Every midnight, you will receive an email with budgeting metrics for the day. 

Take a look at the [read email feature](http://github.com/winton/sum/blob/master/features/read_email.feature) to see example budget email scenarios.

Development setup
-----------------

Install the sum gem for its dependencies:

<pre>
sudo gem install sum --source http://gemcutter.org
</pre>

Fork the [Sum repository](http://github.com/winton/sum) on [GitHub](http://github.com).

<pre>
git clone git@github.com:YOUR_NAME/sum.git
cd sum
</pre>

Copy and edit the example config files:

<pre>
cp config/database.example.yml config/database.yml
cp config/mail.example.yml config/mail.yml
mate config/database.yml config/mail.yml
</pre>

Create and migrate your database:

<pre>
rake db:create db:migrate
</pre>

Start the application with shotgun:

<pre>
shotgun
</pre>

Architecture
------------

The application consists of a simple form that updates the user table and a non-public-facing action that doubles as a background job. The background action is designed to be <code>curl</code>ed by cron every minute. It handles email and time-sensitive user updates.

Running the test suite
----------------------

Sum uses [Cucumber](http://github.com/aslakhellesoy/cucumber), [Webrat](http://github.com/brynary/webrat), and [email-spec](http://github.com/bmabey/email-spec) for functional tests and [rspec](http://github.com/dchelimsky/rspec) for unit tests:

<pre>
cucumber
spec .
</pre>