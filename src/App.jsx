import { useState } from 'react'
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom'
import ToDoList from './pages/ToDoList'
import About from './pages/About'
import NavBar from './components/NavBar'
import './App.css'

function App() {
  return (
    <Router>
      <div className='App'>
        <NavBar />
        <Routes>
          <Route path="/" element={<ToDoList />}></Route>
          <Route path="/sobreecontato" element={<About />}></Route>
        </Routes>
      </div>
    </Router>
  )
}

export default App
