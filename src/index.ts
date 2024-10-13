import Router from 'universal-router';

const router = new Router([
  { path: '/one', action: () => 'Page One' },
  { path: '/two', action: () => 'Page Two' }
]);

router.resolve({ path: '/one' }).then(result => {
  document.body.innerHTML = result || 'Not found';
});