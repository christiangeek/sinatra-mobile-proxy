 $(document).ready(function(){
    var getPageElementIDFromHashURL = function(HashURL) {return HashURL.substring(2).replace(/\//g,"---").replace(/\./g,"----");}, 
        getHashURLFromPageElementID = function(PageElementID) {return "#!"+(PageElementID.substring(4).replace(/---/g,"/").replace(/----/g,"."));},
        convertLinks = function(){$("body > section a").each(function(index,obj) {
          var $obj = $(obj),
              href = $obj.attr("href");
          if(href.search("://") === -1 && href.search("#!") === -1) {
            $obj.attr("href", "#!"+href);
          } else {
            $obj.attr("target", "_blank");
          };
        });},
        getPage = function(newPageURL, linkElement) {
          var newPageID = getPageElementIDFromHashURL(newPageURL),
              $newPage = $("#page"+newPageID),
              $link = $(linkElement);
          if($newPage.length < 1) {
              if($link) {$link.addClass("loading");};
              $.ajax({
                type: 'GET',
                url: newPageURL.substring(2)+".json",
                dataType: 'json',
                success: function(response) {
                  $("body").append(response.body);
                  convertLinks();
                  if($link) {$link.removeClass("loading");};
                  showPage(newPageURL);
                },
                error: function(xhr, type) {
                  if(xhr && xhr.response) {
                    response = JSON.parse(xhr.response);
                    $("body").append(response.body);
                    convertLinks();
                    if($link) {$link.removeClass("loading");};
                    showPage(newPageURL);
                  }
                }
              });
          } else {
              showPage(newPageURL);
          }  
        },
        showPage = function(newPageURL) {
          var $currentSection = $("section.current"),
              prevPageURL = getHashURLFromPageElementID($currentSection.attr("id")),
              newPageID = "#page"+getPageElementIDFromHashURL(newPageURL),
              $newPage = $(newPageID);
          if($currentSection.attr("id") != newPageID.substring(1)) {
            if(!$currentSection.hasClass("first") && !$newPage.hasClass("left") && !$newPage.hasClass("first")) $currentSection.addClass("left");
            $newPage.addClass("display");
            $(newPageID+" nav a").remove();
            $(newPageID+" nav").prepend("<a href=\""+prevPageURL+"\" class=\"back-button\">Back</a>");
            window.setTimeout(function () {$currentSection.removeClass("current").addClass("reverse"); $newPage.addClass("current"); window.scrollTo(0,0);}, 250);
          }
        };
    
    convertLinks();
    $("body > section").first().addClass("current");
    
    window.scrollTo(0,0);
    if(!window.location.hash) {}
    if(window.location.hash) {
      var old_hash = window.location.hash;
      if(window.history.replaceState) window.history.replaceState(null, null, window.location.pathname + "#!"+ window.location.pathname);
      if(window.history.pushState) window.history.pushState(null, null, window.location.pathname + old_hash);
      getPage(old_hash);
    } else {
      if(window.history.replaceState) {
        window.history.replaceState(null, null, window.location.pathname + "#!"+ window.location.pathname);
      } else {
        window.location.href = window.location.pathname + "#!"+ window.location.pathname;
      }
    }
    $(window).bind("hashchange", function(e) {
      if(window.location.hash) {
        getPage(window.location.hash);
      }
    });

    $("body > section").live('webkitTransitionEnd', function(event) {
      if($(event.currentTarget).css("-webkit-transform") === "matrix(1, 0, 0, 1, 0, 0)") {
       $("section").removeClass("display").removeClass("reverse");
       $(event.currentTarget).addClass("display");
       $(event.currentTarget).removeClass("left");
      }
    });
    
    $("menu a[href]").live('click', function(event) {
      var $obj = $(event.currentTarget);
      getPage($obj.attr("href"),$obj);
      if(window.history.pushState) {
        window.history.pushState(null, null, window.location.pathname + $obj.attr("href"));
        event.preventDefault();
      }
    });
    
    $("nav a.back-button").live('click', function(event) {
      window.history.back();
      if(!window.history.pushState) {
        var $obj = $(event.currentTarget);
        getPage($obj.attr("href"),$obj);
      }
      event.preventDefault();
    });
  });