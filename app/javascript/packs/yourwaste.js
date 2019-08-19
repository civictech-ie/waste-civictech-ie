import SearchForm from '../SearchForm.svelte'

document.addEventListener('DOMContentLoaded', () => {
  const target = document.getElementById('search-form');

  const searchForm = new SearchForm({
    target: target,
    props: {
      query: target.getAttribute('data-query')
    }
  });

  window.searchForm = searchForm;
})
