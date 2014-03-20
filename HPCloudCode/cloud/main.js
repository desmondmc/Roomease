
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
response.success("Hello world!");
});

Parse.Cloud.afterSave("House", function(request, response) {
          //TODO need to check if this is the first user moving into the house.
//                      var users = request.object.get("users");
//                      Array(users);
//                      if (users.length == 1)
//                      {
//                        Parse.User.current().set("home", request.object);
//                        Parse.User.current().save();
//                      }
           Parse.User.current().set("home", request.object);
           Parse.User.current().save();
});

//After we save the user we send a silent push out to all the other users in the house to update their Roomease.
Parse.Cloud.afterSave(Parse.User, function(request, response) {
  Parse.Cloud.useMasterKey();

  var queryForHouse = new Parse.Query('House');
  queryForHouse.equalTo('objectId', request.user.get('home').id);
  
  console.log("Searching for House Id:" + request.user.get('home').id);

  queryForHouse.find({
    success: function(results) {
      console.log("Successfully retrieved " + results.length + " Houses.");
      // Do something with the returned Parse.Object values
      for (var i = 0; i < results.length; i++) { 
        var object = results[i];
        console.log(object.id + ' - ' + object.get('name'));

          var queryForInstallation = new Parse.Query(Parse.Installation);
          queryForInstallation.equalTo('channels', object.get('name'));
          
          Parse.Push.send({
            where: queryForInstallation, // Set our Installation query.
            data: {
              //alert: "Hello Des.", // Set our alert message.
              syncRequestKey: 0,
              src_usr: request.object.id
            }
          }).then(function() {
            // Push was successful
            console.log('Sent push.');
          }, function(error) {
            throw "Push Error " + error.code + " : " + error.message;
          });
      }
    },
    error: function(error) {
      console.log("Error finding house: " + error.code + " " + error.message);
    }
  });


});

//Parse.Cloud.afterSave(Parse.User, function(request, response) {
//                      console.log("Running after save on user!");
//                      var House = Parse.Object.extend("House");
//                      var house = new House();
          
//                      var User = Parse.Object.extend("_User");
//                      var user = Parse.User.current();
//                      house = request.user.get("home");
          
          
    
           
          
          
//                      console.log("$$$$$$$$$$$$House: "+ house);
//                      house.fetch({
//                                     success: function(myObject) {
//                                     // The object was refreshed successfully.
//                                        var houseName = house.get("name");
//                                        console.log("Sending push to House: " + houseName);
//                                  
//                                  Parse.Push.send({
//                                                  channels: [ houseName ],
//                                                  data: {
//                                                    "poop": "1"
//                                                  }
//                                                  }, {
//                                                  success: function() {
//                                                  // Push was successful
//                                                  console.log("Sent push!");
//                                                  },
//                                                  error: function(error) {
//                                                  // Handle error
//                                                  console.log("Error sending push! Error: " + error);
//                                                  }
//                                                  });
//                                     },
//                                     error: function(myObject, error) {
//                                     // The object was not refreshed successfully.
//                                     // error is a Parse.Error with an error code and description.
//                                        console.log("Failed to fetch house");
//                                     }
//                                     });
          

          
//});


/************ Jobs *************/


//This function is retardedly complicated. Basicily it checks to see which user objects running ios 7.0.* have not been updated in the last hour and if they haven't it marks them as not home.
Parse.Cloud.job("checkForLost70Users", function(request, status) {
    // Set up to modify user data
    Parse.Cloud.useMasterKey();
    var User = Parse.Object.extend("User");
    
    var query = new Parse.Query(User);
    query.equalTo("iosVersion", "7.0");
    query.notEqualTo("atHome", "unknown");
    
    query.find({
        success: function(results) {
            console.log("Successfully found " + results.length + " ios 7.0.* user(s).");
               // Do something with the returned Parse.Object values
               
            if(results.length == 0)
            {
               status.success("Successful checkForLost70Users job. No users to check.");
            }
            for (var i = 0; i < results.length; i++) {
               var User = Parse.Object.extend("User");
               var object = new User();
               object = results[i];
               
               console.log("Checking time for user: " + object.id);
               var now = new Date();
               object.fetch();
               var updated_at = new Date(object.updatedAt);
               
               var now_seconds = now.getTime() / 1000;
               var updated_at_seconds = updated_at.getTime() / 1000;
               console.log("updated_at value in seconds: " + Math.round(updated_at_seconds));
               
               console.log("now value in seconds: " + Math.round(now_seconds));
               
               var dif_seconds = now_seconds - updated_at_seconds;
               
               console.log("Difference in time: " + dif_seconds);
               
               var secondsIn2Hours = 60*60*2;
               if (dif_seconds > secondsIn2Hours)
               {
                    object.set("atHome", "unknown");
                    console.log("Saving user object:" + object);
               
                    object.save(null, {
                           success: function(object) {
                                console.log("Successfully saved user.");
                           
                           //Check if this is the last user.
                                if (i == (results.length - 1))
                                {
                                    status.success("Successful checkForLost70Users job. Updated at least one user");
                                    return;
                                }
                           },
                           
                           error: function(object, error) {
                                console.log("Error saving user: " + error.message);
                                if (i == (results.length - 1))
                                {
                                    status.error("Error running checkForLost70Users job.");
                                    return;
                                }
                           }
                    });
               }
               else
               {
                console.log("We are still tracking this user do not mark him as not home.");
                if (i == (results.length - 1))
                {
                    status.success("Successful checkForLost70Users job. Checked at least one user.");
                }
               }

               
               
            }
            
        },
        error: function(error) {
               console.log("Error: " + error.code + " " + error.message);
               status.error("Error running checkForLost70Users job. Error on find.");
        }
    });
});