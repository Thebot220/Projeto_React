function Todo({ todo, eraseToDo, completeToDo }){
    return (
        <div className="todo">
            <div className="content">
                <p>{todo.text}</p>
                <p className="category">({todo.category})</p>
            </div>
            <div className="buttons">
                <button className="complete" onClick={() => completeToDo(todo.id)}>Completar</button>
                <button className="erase" onClick={() => eraseToDo(todo.id)}>X</button>
            </div>
        </div>
    )
}

export default Todo