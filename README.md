#Automate Google SignIn

googleSignIn.rb is simple ruby script intended to automate testing of google sign-in page based on the test data.
It gets the test data from a saperate .yml file and test the web page. The script also takes screenshots after every operation and creates saperate zip files for each testcase. 

###Gems
<hr>
####Waitr-webdriver:
"Watir" stands for "Web Application Testing in Ruby", it is an automated test tool which uses the Ruby scripting language to drive the web browser.<br> 
For installation guidelines ans description visit<br> 
                http://watir.com/installation/

####rubyzip:
rubyzip is a ruby module for reading and writing zip files. rubyzip is available on ruby gems.<br/>
Installation: ```gem install rubyzip```

####data_magic:
data_magic is an easy to use gem that provides datasets that can be used by your application and tests. The data is stored in yaml files.<br>
visit https://github.com/cheezy/data_magic for more details and usage.<br>
Installation: ```gem install data_magic```

####fileutils:
A set of utility classes to extract meta data from different file types.<br>
Installation: ```gem install fileutils```
