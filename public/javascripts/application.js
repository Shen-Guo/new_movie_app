var indexFun=new function(){
var search_btn = document.querySelector('.search-btn');
var input = document.querySelector('.input');
var movieSearchForm = document.querySelector('.movie-search')
var handleClick =function(){
  
  event.preventDefault();
  input.value = input.value.trim(); 
  movieSearchForm.submit();
}

search_btn.addEventListener('click',handleClick)
}