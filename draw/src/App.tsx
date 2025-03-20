// import { useState } from 'react'
// import reactLogo from './assets/react.svg'
// import viteLogo from '/vite.svg'
import './App.css'
import "@excalidraw/excalidraw/index.css";
import { Excalidraw } from '@excalidraw/excalidraw'
import { LibraryItems } from '@excalidraw/excalidraw/types';
// import { useRef } from 'react';
// import { ExcalidrawImperativeAPI, LibraryItems } from '@excalidraw/excalidraw/types';

// TODO Fix ext library import
// TODO Make easy progressive web app?
// Migrate to preact

function App() {
  // const [count, setCount] = useState(0)

  // const excalidrawRef = useRef<ExcalidrawImperativeAPI | null>(null);

  const handleLibraryLoad = async () => {
    debugger
    if (excalidrawRef.current) {
      try {
        const response = await fetch(
          "https://libraries.excalidraw.com/libraries/youritjang/software-architecture.excalidrawlib"
        );
        if (response.ok) {
          const libraryJson = await response.json();
          // excalidrawRef.current.updateLibrary(JSON.stringify(libraryJson));
          console.log(libraryJson);
          debugger;
          // console.log("Library loaded successfully!");
        } else {
          console.error("Failed to load the library. Status:", response.status);
        }
      } catch (error) {
        console.error("An error occurred while loading the library:", error);
      }
    }
  };

  // const handleLibraryLoad = () => {
  //   if (excalidrawRef.current) {
  //     excalidrawRef.current.importLibrary(
  //       "https://libraries.excalidraw.com/libraries/youritjang/software-architecture.excalidrawlib"
  //     );
  //   }
  // };

  return (
    <>
      {/* <div>Hello</div> */}
      <div className='wrapper'>
        <button onClick={handleLibraryLoad}>Load Library</button>
        <Excalidraw onLibraryChange={(libraryItems: LibraryItems) => {
          console.warn(libraryItems)
          // debugger
        }} />
      </div>
      {/* <div>
        <a href="https://vite.dev" target="_blank">
          <img src={viteLogo} className="logo" alt="Vite logo" />
        </a>
        <a href="https://react.dev" target="_blank">
          <img src={reactLogo} className="logo react" alt="React logo" />
        </a>
      </div>
      <h1>Vite + React</h1>
      <div className="card">
        <button onClick={() => setCount((count) => count + 1)}>
          count is {count}
        </button>
        <p>
          Edit <code>src/App.tsx</code> and save to test HMR
        </p>
      </div>
      <p className="read-the-docs">
        Click on the Vite and React logos to learn more
      </p> */}
    </>
  )
}

export default App
