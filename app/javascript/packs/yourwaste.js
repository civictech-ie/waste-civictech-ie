import SearchForm from '../SearchForm.svelte'

document.addEventListener('DOMContentLoaded', () => {
  const target = document.getElementById('search-form');

  const searchForm = new SearchForm({
    target: target
  });

  window.searchForm = searchForm;
})
