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

 // Shrink the navbar 
 navbarShrink();

 // Shrink the navbar when page is scrolled
 document.addEventListener('scroll', navbarShrink);
  