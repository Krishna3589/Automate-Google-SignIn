#Script to automate google sign-in using Ruby+Watir
#Test data is stored in a saperate .yml file and is accessed using DataMagic
#Function to take screenshots and the screenshots are saved in a saperate 'temp' folder

require 'watir-webdriver'
require 'data_magic'
require 'zip'
require 'fileutils'
include DataMagic

DataMagic.yml_directory = "/home/krishna/Automate-Google-SignIn/"
DataMagic.load "testdata.yml"
$browser = Watir::Browser.new :firefox
$browser.window.maximize

$zip_folder = "/home/krishna/Automate-Google-SignIn/temp/"     #Folder where the zip files will be saved
FileUtils.rm_rf("#{$zip_folder}.")          #Removes the files that are previously created
$image_folder = "/home/krishna/Automate-Google-SignIn/temp/tmp/"       #Temporary folder to save image files
FileUtils.mkdir("#{$image_folder}")         #Create the temporary directory
$var = "Testcase"
$testcase = ""

class Functions
    def initialize
        @var2 = 1
    end
    #Method to take screenshots
    def take_screenshot
        $browser.screenshot.save "#{$image_folder}#{$testcase}_#{@var2}.png"
        @var2+=1
    end
    #Method to create Zip files
    def zipfiles
        @zipfile_name = "#{$zip_folder}#{$testcase}.zip"
        Zip::File.open("#{@zipfile_name}", Zip::File::CREATE) do |zipfile|
            Dir.glob("#{$image_folder}#{$testcase}*").each do |filename|
                file = File.basename("#{filename}")
                zipfile.add(file, "#{$image_folder}" + file)
            end
        end
    end
    #Method to perform operations like click and set
    def browser_operation(type, id, value, data="")
        take_screenshot
        case type
            when 'link'
                $browser.link(:"#{id}" => "#{value}").when_present.click
            when 'button'
                $browser.button(:"#{id}" => "#{value}").when_present.click
            when 'text_field'
                $browser.text_field(:"#{id}" => "#{value}").when_present.set "#{data}"
            else
                puts "ERROR: Unhandled type #{type}"
        end
    end
    #Method to get error messages  
    def get_error_msg(value, id = "id")
        take_screenshot
        return $browser.span(:"#{id}" => "#{value}").text
    end
    #Method to check whether a text_field is present or not
    def check_exist(type, value)
        return $browser.text_field(:"#{type}" => "#{value}").exist?
    end
end

for i in 1..9
    $testcase = "#{$var}_" + "#{i}".rjust(3,'0')
    testData = data_for :"#{$testcase}"
    puts "#{$testcase}:"
    puts testData.inspect       #Prints the hash data as a string
    test = Functions.new
    $browser.goto "#{testData['url']}"
    test.browser_operation('link', 'id', 'gb_70')
    #If email is already present then select sign-in with a different account to re-enter email
    if $browser.span(:id => "reauthEmail").exist?
        test.browser_operation('link', 'id', 'account-chooser-link')
        test.browser_operation('link', 'id', 'account-chooser-add-account')
    end
    #Enter email and click next
    test.browser_operation('text_field', 'id', 'Email', "#{testData['email']}")
    test.browser_operation('button', 'id', 'next')
    #Wait before checking the condition for error message
    Watir::Wait.until { test.check_exist('class', 'form-error') || test.check_exist('id', 'Passwd') }
    #To check if the error message is present or not
    if test.check_exist('class', 'form-error')
        err_msg = test.get_error_msg('errormsg_0_Email')
        puts "Actual result: #{err_msg}"
        err_msg === testData['expected_result'] ? (puts "Testcase Pass\n\n") : (puts "Testcase Fail\n\n")
        test.zipfiles
        next
    elsif !testData.key?('password')        #If password not present then skip to next loop, do not continue to enter password page
        test.take_screenshot
        puts "Actual result: Email is accepted"
        "Email is accepted" === "#{testData['expected_result']}" ? (puts "Testcase Pass\n\n") : (puts "Testcase Fail\n\n")
        test.zipfiles
        next
    end
    test.browser_operation('text_field', 'id', 'Passwd', "#{testData['password']}")
    #Condition to check or uncheck the stay signed-in checkbox if it exists in test data
    if testData.key?('signincheck')
        "#{testData['signincheck']}" === "true" ? $browser.checkbox(:id => "PersistentCookie").set(true) 
                                     : $browser.checkbox(:id => "PersistentCookie").set(false)
    end
    test.browser_operation('button', 'id', 'signIn')
    Watir::Wait.until { test.check_exist('class', 'form-error') || $browser.link(:title => "Google Account: #{testData['email']}").exist? }
    #Check whether user is logged in or not
    if test.check_exist('class', 'form-error')
        err_msg = test.get_error_msg('errormsg_0_Passwd')
        puts "Actual result: #{err_msg}"
        err_msg === testData['expected_result'] ? (puts "Testcase Pass\n\n") : (puts "Testcase Fail\n\n")
        test.zipfiles
        next
    elsif $browser.link(:title => "Google Account: #{testData['email']}").exist?
        puts "Actual result: Login success"
        "Login success" === "#{testData['expected_result']}" ? (puts "Testcase Pass\n\n") : (puts "Testcase Fail\n\n")
        #If the user is signed in then sign out
        test.browser_operation('link', 'class', 'gb_pa gb_l gb_r gb_h')
        test.browser_operation('link', 'id', 'gb_71')
        Watir::Wait.until { $browser.link(:id => "gb_70").exist? }  #To make sure the user is signed out
        test.zipfiles
    end  
end
$browser.close
FileUtils.rm_rf("#{$image_folder}")     #Deletes the temporary directory containing images
puts "All zip files containing screenshots saved to #{$zip_folder}"
