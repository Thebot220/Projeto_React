import { useState } from 'react'
import ToDoForm from '../components/ToDoForm'
import Todo from '../components/Todo'
import Search from '../components/Search'

function ToDoList() {
    const [todos, setTodos] = useState([
    {
      id: 1,
      text: "Apresentar trabalho de React",
      category: "Trabalho",
      isCompleted: false,
    },
    {
      id: 2,
      text: "Assar um bolo",
      category: "Pessoal", 
      isCompleted: false,
    },
    {
      id: 3,
      text: "Estudar pra prova",
      category: "Estudo",
      isCompleted: false,
    }
    ])

    const [search, setSearch] = useState("")

    function addToDo(text, category) {
    const newToDos = [
    ...todos, 
    {
    id: Math.floor(Math.random() * 10000),
    text,
    category,
    isCompleted: false,
    },
    ]

    setTodos(newToDos)
    }

    function eraseToDo(id) {
    const newToDos = [...todos]
    const filteredToDos = newToDos.filter(todo => todo.id != id ? todo : null)
    setTodos(filteredToDos)
    }

    function completeToDo(id) {
    const newToDos = [...todos]
    newToDos.map((todo) => todo.id === id ? todo.isCompleted = !todo.isCompleted : todo)
    setTodos(newToDos)
    }

    return (
        <>
            <div className='container'>
                <div className='section'>
                    <h1>Lista de Tarefas - Protótipo</h1>
                    <ToDoForm addToDo={addToDo} />
                </div>
                <div className='section'>
                    <Search search={search} setSearch={setSearch}/>
                    <div className='toDoList'>
                        {todos.filter(todo => {if (search.trim() === "" ) return false; return todo.text.toLowerCase().includes(search.toLowerCase())}).map((todo) => (
                        <Todo className="todo" key={todo.id} eraseToDo={eraseToDo} completeToDo={completeToDo} todo={todo}/>
                        ))}
                    </div>
                </div>
            </div>
            <div className='container'>
                <div className='pendentes'>
                    <h2>Pendentes</h2>
                    <div className='toDoList'>
                    {todos.filter(todo => !todo.isCompleted).map((todo) => (
                    <Todo className="todo" key={todo.id} eraseToDo={eraseToDo} completeToDo={completeToDo} todo={todo}/>
                    ))}
                    </div>
                </div>
                <div className='section'>
                    <h2>Concluídas</h2>
                    <div className='toDoList'>
                        {todos.filter(todo => todo.isCompleted).map((todo) => (
                        <Todo className="todo" key={todo.id} eraseToDo={eraseToDo} completeToDo={completeToDo} todo={todo}/>
                        ))}
                    </div>
                </div>
            </div>
        </>
    )
}

export default ToDoList