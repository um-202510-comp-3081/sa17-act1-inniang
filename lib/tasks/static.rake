namespace :static do
  desc 'Generate static version of the site'
  task :generate => :environment do
    # Create build directory
    build_dir = Rails.root.join('build')
    FileUtils.rm_rf(build_dir)
    FileUtils.mkdir_p(build_dir)

    # Copy all files from public directory
    FileUtils.cp_r(Dir[Rails.root.join('public/*')], build_dir)

    # Generate the main index.html
    File.open(build_dir.join('index.html'), 'w') do |f|
      f.write <<-HTML
<!DOCTYPE html>
<html>
<head>
  <title>Todo App</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body { padding: 20px; }
    .todo-item { margin-bottom: 10px; }
    .completed { text-decoration: line-through; }
  </style>
</head>
<body>
  <div class="container">
    <h1 class="mb-4">Todo List</h1>
    
    <div class="row">
      <div class="col-md-6">
        <div class="card">
          <div class="card-body">
            <h5 class="card-title">Add New Todo</h5>
            <form id="todo-form">
              <div class="mb-3">
                <input type="text" class="form-control" id="todo-input" placeholder="Enter your todo">
              </div>
              <button type="submit" class="btn btn-primary">Add Todo</button>
            </form>
          </div>
        </div>

        <div class="mt-4">
          <h5>Your Todos:</h5>
          <div id="todo-list">
            <!-- Todos will be added here dynamically -->
          </div>
        </div>
      </div>
    </div>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  <script>
    document.addEventListener('DOMContentLoaded', function() {
      const todoForm = document.getElementById('todo-form');
      const todoInput = document.getElementById('todo-input');
      const todoList = document.getElementById('todo-list');
      
      let todos = JSON.parse(localStorage.getItem('todos') || '[]');
      
      function saveTodos() {
        localStorage.setItem('todos', JSON.stringify(todos));
      }
      
      function renderTodos() {
        todoList.innerHTML = '';
        todos.forEach((todo, index) => {
          const div = document.createElement('div');
          div.className = 'todo-item d-flex align-items-center';
          div.innerHTML = `
            <input type="checkbox" class="form-check-input me-2" ${todo.completed ? 'checked' : ''}>
            <span class="${todo.completed ? 'completed' : ''}">${todo.text}</span>
            <button class="btn btn-danger btn-sm ms-auto">Delete</button>
          `;
          
          const checkbox = div.querySelector('input');
          checkbox.addEventListener('change', () => {
            todos[index].completed = checkbox.checked;
            saveTodos();
            renderTodos();
          });
          
          const deleteBtn = div.querySelector('.btn-danger');
          deleteBtn.addEventListener('click', () => {
            todos.splice(index, 1);
            saveTodos();
            renderTodos();
          });
          
          todoList.appendChild(div);
        });
      }
      
      todoForm.addEventListener('submit', (e) => {
        e.preventDefault();
        const text = todoInput.value.trim();
        if (text) {
          todos.push({ text, completed: false });
          saveTodos();
          renderTodos();
          todoInput.value = '';
        }
      });
      
      renderTodos();
    });
  </script>
</body>
</html>
      HTML
    end

    puts "Static files generated in build directory"
  end

  desc 'Deploy to gh-pages branch'
  task :deploy => :generate do
    # Ensure we're on gh-pages branch
    system 'git checkout gh-pages'
    
    # Copy build contents to root
    FileUtils.cp_r(Dir[Rails.root.join('build/*')], Rails.root)
    
    # Add and commit changes
    system 'git add .'
    system 'git commit -m "Update static site"'
    system 'git push origin gh-pages'
    
    puts "Deployed to gh-pages branch"
  end
end 