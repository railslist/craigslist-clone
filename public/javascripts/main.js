const rightbarDropdownClick = (event) => {
  const rightbarDropdowns = document.querySelectorAll('.dropdown');
  const rightbarDropdownBtns = document.querySelectorAll('.dropdown-btn');
  const rightbarDropdownsBtnArrows = document.querySelectorAll('.dropdown-btn-arrow');

  const clickedDropdownName = event.target.dataset.dropdown;
  // const currentDropdown = document.querySelector(`#${currentDropdownName}-dropdown`);
  // const currentDropdownBtn = document.querySelector('.dropdown-btn')
  // const currentDropdownBtnArrow = document.querySelector(`#${currentDropdownName}-dropdown-btn-arrow`);

  rightbarDropdowns.forEach((dropdown) => {
    if (dropdown.dataset.name === clickedDropdownName) {
      dropdown.classList.remove('collapsed');
    } else {
      dropdown.classList.add('collapsed');
    }
  });
  rightbarDropdownBtns.forEach((btn) => {
    if (btn.dataset.name === clickedDropdownName) {
      dropdown.classList.remove('collapsed');
    } else {
      dropdown.classList.add('collapsed');
      btn.classList.add('disabled');
    }
  });
  rightbarDropdownsBtnArrows.forEach((arrow) => arrow.classList.add('right'));
  currentDropdown.classList.remove('collapsed');
  currentDropdownBtn.classList.remove('disabled');
  currentDropdownBtnArrow.classList.remove('right');
};
