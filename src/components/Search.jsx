function Search({ search, setSearch }) {
    return (
        <div className="Search">
            <h2>Pesquise uma Tarefa</h2>
            <input type="text" value={search} placeholder="Digite sua pesquisa aqui" onChange={(e) => setSearch(e.target.value)} />
        </div>
    )
}

export default Search