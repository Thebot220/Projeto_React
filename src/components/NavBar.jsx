import { Link } from "react-router-dom"
import preto1 from './preto1.png'

function NavBar() {
    return (
        <div className="navbar">
            <img src={preto1} alt="Logo ScitecJr" />
            <div>
                <ul className="lnavbar">
                    <li><Link className="link" to="/">Lista de Tarefas</Link></li>
                    <li><Link className="link" to="/sobreecontato">Sobre o Trabalho</Link></li>
                </ul>
            </div>
        </div>
    )
}

export default NavBar