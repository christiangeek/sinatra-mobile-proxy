Feature: View content formatted for my browser
  Since this is a mobile web proxy
  I want to see content 
    
  Scenario: View the homepage and see relevant site info
    Given I am on the homepage
    Then I should see "Test Site" within "title"
    And I should have the header "ETag"
    And I should have the header "Expires"
    And I should have the header "Last-Modified"
    And I should have the header "Cache-Control"
    And I should see a image with the src "http://localhost:9191/logo.png" and the height of "34px" and the width of "100px" within the "header" element
    And I should see a link with the url "http://localhost:9191" and the text "Test Site" within the "footer" element
    And I should see a link with the url "http://localhost:9191/?mobile=false" and the text "View Full Site" within the "footer" element
    
  Scenario: View the homepage and the CSS should be loaded inline
    Given I am on the homepage
    Then I should see "body > section" within "style"
    
  Scenario: View the homepage and there should not be any inline JavaScript loaded when not using a WebKit browser
    Given I am on the homepage
    Then I should not see the element "script"
    
  Scenario: View the homepage and see a link to the About page
    Given I am on the homepage
    Then I should see a link with the url "/about" and the text "About" within the "section menu" element
    
  Scenario: Click a link to the About page and see the About page
    Given I am on the homepage
    When I follow "About" within "section menu"
    Then I should be on the about page
  
  Scenario: Try to access a non html resource and should be redirected to the correct resource
    Given I am on the local logo path
    Then I should see content of the type "image/png"
    
  @javascript  
  Scenario: View the homepage and see a link to the About page
    Given I am on the homepage
    Then I should see the hash "#!/" in the location bar
    And I should see a link with the url "#!/about" and the text "About" within the "section menu" element

  @javascript  
  Scenario: Click a link to the About page and see the About page with a webkit browser
    Given I am on the homepage
    When I sleep 3
    And I follow "About" within "section menu"
    And I wait until "page---about" is visible
    Then I should see the hash "#!/about" in the location bar
    And I should see "None is righteous, no, not one;" within "section.current article"
    And I should see a link with the url "#!/" and the text "Back" within the "section.current nav" element
    And I should see "Passage: Romans 3 (ESV Bible Online)" within "section.current nav span.page-title"
    And I should not see "More about the ESV Bible"
    
  Scenario: View a remote page and it should be loaded into the cache
    Given I am on the about page
    Then I should see "Passage: Romans 3 (ESV Bible Online)" within "title"
    And I should have the header "ETag"
    And I should have the header "Expires"
    And I should have the header "Last-Modified"
    And I should have the header "Cache-Control"
    And I should see "None is righteous, no, not one;" within "section article"
    And I should see a link with the url "/" and the text "Home" within the "section.display nav" element
    And I should see "Passage: Romans 3 (ESV Bible Online)" within "section.first nav span.page-title"
    And I should not see "More about the ESV Bible"
  
  @javascript  
  Scenario: View a remote page and it should be loaded into the cache using a webkit browser
    Given I am on the about page
    Then I should see the hash "#!/about" in the location bar
    And I should see "Passage: Romans 3 (ESV Bible Online)" within "title"
    And I should see "None is righteous, no, not one;" within "section.current article"
    And I should see a link with the url "#!/" and the text "Home" within the "section.current nav" element
    And I should see "Passage: Romans 3 (ESV Bible Online)" within "section.current nav span.page-title"
    And I should not see "More about the ESV Bible"
    
  @javascript  
  Scenario: View the homepage and set the hash to the About page and see the About page and go back and see the homepage and go forward see the About page again
    Given I am on the home page
    When I set the hash to "#!/about"
    And I wait until "page---about" is visible
    Then I should see the hash "#!/about" in the location bar
    And I should see "None is righteous, no, not one;" within "section.current article"
    And I should see a link with the url "#!/" and the text "Back" within the "section.current nav" element
    And I should see "Passage: Romans 3 (ESV Bible Online)" within "section.current nav span.page-title"
    When I click the back button on my browser
    And I wait until "page---" is visible
    Then I should see the hash "#!/" in the location bar 
    And I should see a link with the url "#!/about" and the text "About" within the "section menu" element
    When I click the forward button on my browser
    And I wait until "page---about" is visible
    Then I should see the hash "#!/about" in the location bar
    And I should see "None is righteous, no, not one;" within "section.current article"
    And I should see a link with the url "#!/" and the text "Back" within the "section.current nav" element
    And I should see "Passage: Romans 3 (ESV Bible Online)" within "section.current nav span.page-title"
  
  Scenario: View a remote page and see relevant site info
    Given I am on the about page
    Then I should see a image with the src "http://localhost:9191/logo.png" and the height of "34px" and the width of "100px" within the "header" element
    And I should see a link with the url "http://localhost:9191" and the text "Test Site" within the "footer" element
    And I should see a link with the url "http://localhost:9191/?mobile=false" and the text "View Full Site" within the "footer" element
    
  Scenario: View a remote page and the CSS should be loaded inline
    Given I am on the about page
    Then I should see "body > section" within "style"
    
  Scenario: View the homepage and there should not be any inline JavaScript loaded when not using a WebKit browser
    Given I am on the about page
    Then I should not see the element "script"
    
  Scenario: View a non-existent page and see a 404
    Given I am on the missing page
    Then I should see "This is embarrassing...the page you are looking for is lost."
    And I should see a link with the url "/" and the text "Home" within the "section.display nav" element
    And I should see "Page not found" within "section.first nav span.page-title"  
    
  @javascript 
  Scenario: View a non-existent page and see a 404 using a webkit browser
    Given I am on the missing page
    Then I should see "This is embarrassing...the page you are looking for is lost."
    And I should see a link with the url "#!/" and the text "Home" within the "section.display nav" element
    And I should see "Page not found" within "section.first nav span.page-title"
    
  Scenario: View the application manifest and see pages listed
    Given I am on the application manifest
    Then I should see content of the type "text/cache-manifest;charset=utf-8"
    And I should have the header "ETag"
    And I should have the header "Expires"
    And I should have the header "Last-Modified"
    And I should have the header "Cache-Control"
    And I should see "/about"
    And I should not see "/about.json"
    
  @javascript
  Scenario: View the application manifest and see pages listed as JSON in webkit browser
    Given I am on the application manifest
    And I should see "/about.json"