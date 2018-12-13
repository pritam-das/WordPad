var ajaxLoadedWords = false; //variable that prevents ajax calls from firing twice
var ajaxLoadedOptions = false;

$(".users.dictionary").ready(function(){

  handleWords();

  handleOptions();

});

function handleWords(){
  //section where user searches for a word and the meaning is flashed
  var formGrabber = document.getElementById('new_word');
  var container = document.getElementById('page_container');

  formGrabber.addEventListener('submit', function(event){
      event.preventDefault();
      var termGrabber = document.getElementById('word_term').value;

      $.ajax({
        // sending it to flash_meaning controller
        url: '/words/flash_meaning',
        type: 'GET',
        data: {
          word: {
            term: termGrabber
          }
        },
        dataType: 'json'
      }).done( function(responseData) {

        if (!ajaxLoadedWords) {
          //disable the form button
          ajaxLoadedWords = true;
          var buttonGrabber = document.getElementById('meaning_button');
          buttonGrabber.hidden = "true";

          //create a new div and append the term's meaning to show to user
          var divTag = document.createElement('div');
          divTag.innerText = "Meaning of " + termGrabber + " is " + responseData.meaning;
          formGrabber.append(divTag);

          //ask user whether he wants to add it to dictionary
          var divTag2 = document.createElement('div');
          divTag2.innerText = "Want to add it to your Wordpad?";
          divTag.append(divTag2);

          //button that handles saving to dictionary
          var choiceButtonYes = document.createElement('input');
          choiceButtonYes.setAttribute('type', 'submit');
          choiceButtonYes.setAttribute('value', 'Yes');
          container.append(choiceButtonYes);
          choiceButtonYes.addEventListener('click', saveWord);

          //button that handles discard
          var choiceButtonDiscard = document.createElement('input');
          choiceButtonDiscard.setAttribute('type', 'submit');
          choiceButtonDiscard.setAttribute('value', 'No');
          container.append(choiceButtonDiscard);
          choiceButtonDiscard.addEventListener('click', resetPage);

          //handles resetting the page
          function resetPage(){
              choiceButtonYes.remove();
              formGrabber.reset();
              buttonGrabber.removeAttribute('hidden');
              buttonGrabber.removeAttribute('disabled');
              buttonGrabber.removeAttribute('data-disable-with');
              console.log(buttonGrabber);

              divTag.remove();
              divTag2.remove();

              choiceButtonYes.removeEventListener('click',null);
              formGrabber.removeEventListener('submit', null);
              choiceButtonDiscard.removeEventListener('click', null);
              choiceButtonDiscard.remove();

              ajaxLoadedWords = false;
              handleWords();
          };

          //handles when user wants to save the word to the dictionary
          function saveWord(){
            $.ajax({
                url: formGrabber.action,
                type: formGrabber.method,
                data: { word:
                {
                  term: termGrabber,
                  meaning: responseData.meaning
                }},
                dataType: 'json'
            }).done(function(responseData2){
              console.log(typeof responseData2);

              //if word exists in user's dictionary
              if (typeof responseData2 == 'string') {
                resetPage();

                var modalTag = document.createElement('div');
                modalTag.setAttribute('class', 'modal');
                var modalContentTag = document.createElement('div');
                modalContentTag.setAttribute('class', 'modal-content');
                modalContentTag.innerHTML = "<p>" + responseData2 + "</p>"
                modalTag.append(modalContentTag);
                container.append(modalTag);

                setTimeout(function(){
                  modalTag.remove();
                }, 2500);
              }
              // if no duplication of word
              else {
              //handles prepending the words to the list in dictionary
              var listTag = document.createElement('li');
              listTag.innerHTML = "<strong>" + responseData2.term +"</strong>: " + responseData2.meaning;
              document.getElementById('word-meaning').prepend(listTag);
              resetPage();
              }
            });
          };







        };





      });

  });
};

function handleOptions(){
    var selectGrabber = document.getElementById('optionsSelector');
    var container = document.getElementById('page_container');

    selectGrabber.addEventListener('change', function(event){


      var list = document.querySelectorAll('ul');
      var addedTodayDone = false;
      // if (this.value == 'addedToday') {
        // if (!addedTodayDone) {

          //hide all list before change
          list.forEach(function(list){
            list.hidden = 'true';
          });

          $.ajax({
            url: '/users/sort_list',
            method: 'GET',
            data: {
              value: this.value
            },
            dataType: 'json'
          }).done(function(addedTodayResponse){
                if (!ajaxLoadedOptions) {

                    ajaxLoadedOptions = true;
                    console.log(ajaxLoadedOptions);
                    var ulTag = document.createElement('ul');
                    ulTag.setAttribute('id', 'word-meaning');

                    addedTodayResponse.forEach(function(word){
                      var li = document.createElement('li');
                      li.innerHTML = "<strong>" + word.term + "</strong>: " + word.meaning;
                      ulTag.append(li);
                    });
                    // ulTag.removeAttribute('hidden');
                    dropdown_sort.append(ulTag);
                    addedTodayDone = true;
                    // console.log(addedTodayDone);
                };


          });
        // }
                  ajaxLoadedOptions = false;
                  console.log(ajaxLoadedOptions);
                  selectGrabber.removeEventListener('change', null);
                  handleOptions();

      // }
      // else if (this.value == 'addedYesterday'){
      //   list.removeAttribute('hidden');
      // }
    });


}
