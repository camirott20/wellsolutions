var redirectTo = function () {
    var queryParams = new URLSearchParams(location.search)
    if (queryParams.has("sent") || queryParams.has("fail")) {
        var element = document.querySelector('#contacto')
        if (element)
            window.scrollTo(0, element.offsetTop);
    }
}

document.querySelectorAll('.dropdown-toggle').forEach(item => {
    item.addEventListener('click', event => {

        if(event.target.classList.contains('dropdown-toggle') ){
        event.target.classList.toggle('toggle-change');
        }
        else if(event.target.parentElement.classList.contains('dropdown-toggle')){
        event.target.parentElement.classList.toggle('toggle-change');
        }
    })
});

var navbarShrink = function () {
    const navbarCollapsible = document.body.querySelector('#navbar');
    if (!navbarCollapsible)
        return;

    if (window.scrollY === 0) 
        navbarCollapsible.classList.remove('navbar-shrink', 'shadow-lg');
    else 
        navbarCollapsible.classList.add('navbar-shrink', 'shadow-lg');
};

var hiddenSpinner = function () {
    setTimeout(function () {
        document.body.classList.remove("overflow-hidden");
    
        const spinner = document.body.querySelector("#spinner")

        if (spinner) {
            spinner.classList.add("d-none");
    }
    }, 500);
}

 // Shrink the navbar when page is scrolled
 document.addEventListener('scroll', navbarShrink);


 // Shrink the navbar 
 navbarShrink();
 hiddenSpinner();
 redirectTo();

  