Then /^(?:|I )should see (\d+) links in the footer$/ do |count|
  page.should have_selector("footer a", :count => count)
end

Then /^(?:|I )should see a link with the url "([^"]*)" and the text "([^"]*)" within the "([^"]*)" element$/ do |url, text, element|
  within(element) do
    should have_link(text,:href=>url)
  end
end

Then /^(?:|I )should see a image with the src "([^"]*)" and the height of "([^"]*)" and the width of "([^"]*)" within the "([^"]*)" element$/ do |src, height, width, element|
  within(element) do
    should have_selector(:xpath, './/img[@src="'+src+'"][@height="'+height+'"][@width="'+width+'"]')
  end
end

Then /^(?:|I )should not see the element "([^"]*)"$/ do |element|
  page.should_not have_selector(element)
end

Then /^(?:|I )should see the hash "([^"]*)" in the location bar$/ do |hash|
  page.evaluate_script('window.location.hash').should == hash
end

Then /^(?:|I )should see content of the type "([^"]*)"$/ do |content_type|
  page.response_headers["Content-Type"].should == content_type
end

Then /^(?:|I )should have the header "([^"]*)"$/ do |header|
  page.response_headers.include?(header).should == true
end

When /^(?:|I )wait until "([^"]*)" is visible$/ do |selector|
  sleep 1
  page.has_css?("#{selector}", :visible => true)
end

When /^(?:|I )sleep (\d+)$/ do |time|
  sleep time.to_i
end

When /^(?:|I )set the hash to "([^"]*)"$/ do |hash|
  page.evaluate_script('window.location.hash = "'+hash+'"')
end

When /^(?:|I )click the back button on my browser$/ do
  page.evaluate_script('window.history.back()')
end

When /^(?:|I )click the forward button on my browser$/ do
  page.evaluate_script('window.history.forward()')
end

