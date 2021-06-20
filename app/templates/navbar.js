const body = document.querySelector("body")


let skipToAbout = document.querySelector("#skipToAbout").addEventListener("click", () => {
    window.alert("Go To About Section");
    window.scrollBy(0,200);
})

let skipToProjects = document.querySelector("#skipToProjects").addEventListener("click", () => {
    window.alert("Go To Projects Section");
    window.scrollBy(0, 400);
  });

let skipToContact = document.querySelector("#skipToContact").addEventListener("click", () => {
    window.alert("Go To Contact Section");
    window.scrollBy(0, 600);
  });