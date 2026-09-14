import { useState } from "react"

function ToDoForm({ addToDo }){
    const [value, setValue] = useState("")
    const [category, setCategory] = useState("")

    function handleSubmit(e) {
        e.preventDefault()
        if (!value || !category) return
        addToDo(value, category)
        setValue("")
        setCategory("")
    }

    return (
            <div className="todoform">
                <h2 className="formTitle">Criar Tarefa</h2>
                <form onSubmit={handleSubmit}>
                    <input type="text" placeholder="Digite aqui a sua nova tarefa" value={value} onChange={(e) => setValue(e.target.value)}/>
                    <select value={category} onChange={(e) => setCategory(e.target.value)}>
                        <option value="">Selecione uma categoria</option>
                        <option value="Estudos">Estudos</option>
                        <option value="Pessoal">Pessoal</option>
                        <option value="Trabalho">Trabalho</option>
                    </select>
                    <button type="submit">Criar Nova Tarefa</button>
                </form>
            </div>
    )
}

export default ToDoForm