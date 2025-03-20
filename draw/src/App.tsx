// import { useState } from 'react'
// import reactLogo from './assets/react.svg'
// import viteLogo from '/vite.svg'
import './App.css'
import "@excalidraw/excalidraw/index.css";
import { Excalidraw, exportToCanvas } from '@excalidraw/excalidraw'
import { AppState, BinaryFiles, ExcalidrawImperativeAPI, LibraryItems } from '@excalidraw/excalidraw/types';
import { useState } from 'react';
import { OrderedExcalidrawElement } from '@excalidraw/excalidraw/element/types';
// import { useRef } from 'react';
// import { ExcalidrawImperativeAPI, LibraryItems } from '@excalidraw/excalidraw/types';

// TODO Fix ext library import
// TODO Make easy progressive web app?
// TODO Fix font loading
// TODO Migrate to preact

function App() {

  const [excalidrawAPI, setExcalidrawAPI] = useState<ExcalidrawImperativeAPI | null>(null);

  function onDrawingChange(elements: readonly OrderedExcalidrawElement[], appState: AppState, files: BinaryFiles): void {
    // excalidrawAPI?.getAppState().
    debugger
    localStorage.setItem("excalidraw-elements", JSON.stringify(elements));
    localStorage.setItem("excalidraw-appState", JSON.stringify(appState));
    localStorage.setItem("excalidraw-files", JSON.stringify(files));

    // excalidrawAPI.
  }

  /*   function exportData(): void {
      // const newLocal = exportToCanvas();
      const state = excalidrawAPI?.getAppState();
      const elements = excalidrawAPI?.getSceneElements();
      console.warn(elements, state);
      debugger;
      // throw new Error('Function not implemented.');
    }
   */
  // const [count, setCount] = useState(0)

  // const excalidrawRef = useRef<ExcalidrawImperativeAPI | null>(null);
  /*
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
    }; */

  // const handleLibraryLoad = () => {
  //   if (excalidrawRef.current) {
  //     excalidrawRef.current.importLibrary(
  //       "https://libraries.excalidraw.com/libraries/youritjang/software-architecture.excalidrawlib"
  //     );
  //   }
  // };

  return (
    <>
      <div className='wrapper'>
        {/* <button onClick={() => exportData()}>export</button> */}
        {/* <button onClick={handleLibraryLoad}>Load Library</button> */}
        <Excalidraw excalidrawAPI={api => setExcalidrawAPI(api)} onChange={onDrawingChange} />
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
