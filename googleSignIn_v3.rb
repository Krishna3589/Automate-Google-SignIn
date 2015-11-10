#Automated script to perform google sign-in using Ruby and watir
#Removed all the sleep statements and replaced them with "when_present"
#Used Hash instead of hard coding values
#Added code to take screenshots whereever necessary
#Included additional conditions to  validate tests
#Replaced a few if-else-end statements with ternary operator

require 'watir-webdriver'
browser = Watir::Browser.new :firefox   #using firefox browser

#using a hash to store data
testData = { :email => "k066016@gmail.com",
             :pass => "610660kcr",
             :url => "http://google.co.in/",
             :wrpass => "123456789",
	         :loc => "/home/krishna/RUBY/temp/"
           }
          
puts "Testcase-01: Sign-in to goolge with correct data
      User Data:
      url : #{testData[:url]}
      email : #{testData[:email]}
      password : #{testData[:pass]}"
        
browser.goto testData[:url]
browser.screenshot.save ("#{testData[:loc]}image001.png")
browser.link(:id => "gb_70").when_present.click
browser.screenshot.save ("#{testData[:loc]}image002.png")
browser.text_field(:id => "Email").when_present.set (testData[:email])
browser.screenshot.save ("#{testData[:loc]}image003.png")
browser.button(:id => "next").click
browser.screenshot.save ("#{testData[:loc]}image004.png")
browser.text_field(:id => "Passwd").when_present.set (testData[:pass])
browser.screenshot.save ("#{testData[:loc]}image005.png")

#condition to check if the checkbox is checked or unchecked
browser.checkbox(:id => "PersistentCookie").set? ? browser.checkbox(:id => "PersistentCookie").set(false) : nil
browser.screenshot.save ("#{testData[:loc]}image006.png")
browser.button(:id => "signIn").click
if browser.link(:title => "Google Account: #{testData[:email]}").exists?
    browser.screenshot.save ("#{testData[:loc]}image007.png")
    puts "Testcase-01 Pass\n\n"
    #signing out from google
    browser.link(:class => "gb_pa gb_l gb_r gb_h").when_present.click
    browser.screenshot.save ("#{testData[:loc]}image008.png")
    browser.link(:id => "gb_71").when_present.click
    browser.screenshot.save ("#{testData[:loc]}image009.png")
else
    browser.screenshot.save ("#{testData[:loc]}image007.png")
    puts "Testcase-01 Fail \n\n"
end
    
#validating login using wrong password
puts "Testcase-02: Sign-in to goolge with incorrect data
      User Data:
      url : #{testData[:url]}
      email : #{testData[:email]}
      password : #{testData[:wrpass]}"
      
browser.link(:id => "gb_70").when_present.click
browser.screenshot.save ("#{testData[:loc]}image010.png")
browser.text_field(:id => "Email").when_present.set (testData[:email])
browser.screenshot.save ("#{testData[:loc]}image011.png")
browser.button(:id => 'next').click
browser.screenshot.save ("#{testData[:loc]}image012.png")
browser.text_field(:id => "Passwd").when_present.set (testData[:wrpass])
browser.screenshot.save ("#{testData[:loc]}image013.png")
browser.button(:id => "signIn").when_present.click
browser.screenshot.save ("#{testData[:loc]}image014.png")

if browser.span(:class => "error-msg").exists?
    browser.screenshot.save ("#{testData[:loc]}image015.png")
    puts "Testcase-02 PASS \n\n"
else
    browser.screenshot.save ("#{testData[:loc]}image015.png")
    puts "Testcase-02 FAIL \n\n"
end

#checking the back arrow image
puts "checking if the back arrow image works or not"
browser.image(:id => "back-arrow").when_present.click
browser.screenshot.save ("#{testData[:loc]}image016.png")
if browser.link(:text => "Create account").exists?
    puts "back image works\n\n"
    browser.button(:id => 'next').when_present.click
	browser.screenshot.save ("#{testData[:loc]}image017.png")
else
    puts "back image fail\n\n"
    browser.back
    browser.screenshot.save ("#{testData[:loc]}image017.png")
end

#checking forgot password link
puts "checking if the Forgot Password link works or not"
browser.screenshot.save ("#{testData[:loc]}image018.png")
browser.link(:id => "link-forgot-passwd").when_present.click
browser.screenshot.save ("#{testData[:loc]}image019.png")
browser.window(:title => "Goolge Account Recovery").exists? ? (puts "forgot password link works\n\n") : 
							    (puts "forgot password link failed\n\n")

browser.back
browser.screenshot.save ("#{testData[:loc]}image020.png")

#checking Sign in with a different account link
puts "checking if the sign in with a different account link works or not"
browser.screenshot.save ("#{testData[:loc]}image021.png")
browser.link(:text => "Sign in with a different account").when_present.click
browser.screenshot.save ("#{testData[:loc]}image022.png")
browser.link(:text => "Create account").exists? ? (puts "sign in with a different account link works\n\n") :
						 (puts "sign in with a different account link fail\n\n")

puts "All screenshots saved to #{testData[:loc]}"
