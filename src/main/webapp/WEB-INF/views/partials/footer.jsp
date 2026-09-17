    </main>
</div>
<script>
    (function () {
        var loanDialog = document.querySelector("[data-loan-dialog]");
        var openLoanDialog = document.querySelector("[data-open-loan-dialog]");
        var closeLoanDialog = document.querySelectorAll("[data-close-loan-dialog]");
        var activeConfirm = null;

        function setButtonBusy(button, text) {
            if (!button) {
                return;
            }
            button.dataset.originalText = button.textContent;
            button.textContent = text || "Please wait...";
            button.disabled = true;
            button.classList.add("is-loading");
        }

        document.querySelectorAll("form[data-busy-message]").forEach(function (form) {
            form.addEventListener("submit", function () {
                var button = form.querySelector("button[type='submit']");
                setButtonBusy(button, form.getAttribute("data-busy-button"));
            });
        });

        function applyStyles(element, styles) {
            Object.keys(styles).forEach(function (key) {
                element.style[key] = styles[key];
            });
        }

        function makeButton(text, danger) {
            var button = document.createElement("button");
            button.type = "button";
            button.textContent = text;
            applyStyles(button, {
                border: danger ? "1px solid rgba(139,58,42,.22)" : "1px solid #d8cfc0",
                borderRadius: "3px",
                background: danger ? "rgba(139,58,42,.1)" : "white",
                color: danger ? "#8b3a2a" : "#1a1208",
                cursor: "pointer",
                fontFamily: "'Outfit', sans-serif",
                fontSize: "12px",
                fontWeight: "500",
                letterSpacing: ".08em",
                minWidth: "112px",
                padding: "12px 20px",
                textTransform: "uppercase"
            });
            return button;
        }

        function closeConfirmModal() {
            if (activeConfirm) {
                activeConfirm.remove();
                activeConfirm = null;
                document.body.classList.remove("has-modal");
            }
        }

        function openConfirmModal(options) {
            closeConfirmModal();

            var backdrop = document.createElement("div");
            applyStyles(backdrop, {
                alignItems: "center",
                background: "rgba(26,18,8,.48)",
                backdropFilter: "blur(5px)",
                display: "flex",
                inset: "0",
                justifyContent: "center",
                padding: "24px",
                position: "fixed",
                zIndex: "1000"
            });

            var card = document.createElement("div");
            applyStyles(card, {
                background: "white",
                borderRadius: "6px",
                boxShadow: "0 28px 70px rgba(26,18,8,.28)",
                maxWidth: "450px",
                padding: "48px 44px 42px",
                textAlign: "center",
                width: "100%"
            });

            var icon = document.createElement("div");
            icon.innerHTML = "&#128465;";
            applyStyles(icon, {
                color: "#aaa2b5",
                fontSize: "42px",
                lineHeight: "1",
                marginBottom: "14px"
            });

            var title = document.createElement("h2");
            title.textContent = options.title || "Confirm Delete";
            applyStyles(title, {
                fontFamily: "'Cormorant Garamond', serif",
                fontSize: "28px",
                fontWeight: "500",
                margin: "0"
            });

            var message = document.createElement("p");
            message.textContent = options.message || "Are you sure you want to delete this record? This cannot be undone.";
            applyStyles(message, {
                color: "#8a8074",
                fontSize: "15px",
                lineHeight: "1.35",
                margin: "14px auto 28px",
                maxWidth: "330px"
            });

            var actions = document.createElement("div");
            applyStyles(actions, {
                display: "flex",
                flexWrap: "wrap",
                gap: "16px",
                justifyContent: "center"
            });

            var cancelButton = makeButton("Cancel", false);
            var deleteButton = makeButton(options.action || "Delete", true);

            cancelButton.addEventListener("click", closeConfirmModal);
            deleteButton.addEventListener("click", function () {
                deleteButton.disabled = true;
                deleteButton.textContent = "Deleting...";
                window.location.href = options.href;
            });

            actions.appendChild(cancelButton);
            actions.appendChild(deleteButton);
            card.appendChild(icon);
            card.appendChild(title);
            card.appendChild(message);
            card.appendChild(actions);
            backdrop.appendChild(card);

            backdrop.addEventListener("click", function (event) {
                if (event.target === backdrop) {
                    closeConfirmModal();
                }
            });

            document.body.appendChild(backdrop);
            document.body.classList.add("has-modal");
            activeConfirm = backdrop;
            cancelButton.focus();
        }

        function showFlashToast() {
            var flash = document.getElementById("flash-message");
            if (!flash || !flash.value) {
                return;
            }
            var toast = document.createElement("div");
            toast.innerHTML = "<span style=\"display:inline-block;width:16px;\">&#10003;</span><span></span>";
            toast.lastChild.textContent = flash.value;
            applyStyles(toast, {
                alignItems: "center",
                background: flash.getAttribute("data-flash-type") === "error" ? "#8b3a2a" : "#1a1208",
                borderRadius: "5px",
                bottom: "32px",
                boxShadow: "0 18px 42px rgba(26,18,8,.24)",
                color: "#faf7f2",
                display: "flex",
                fontSize: "14px",
                fontWeight: "500",
                gap: "8px",
                padding: "15px 20px",
                position: "fixed",
                right: "32px",
                zIndex: "1001"
            });
            document.body.appendChild(toast);
            window.setTimeout(function () {
                toast.remove();
            }, 4500);
        }

        document.querySelectorAll("a[data-busy-message]").forEach(function (link) {
            link.addEventListener("click", function (event) {
                var message = link.getAttribute("data-confirm-message");
                if (message) {
                    event.preventDefault();
                    openConfirmModal({
                        action: link.getAttribute("data-confirm-action") || "Delete",
                        href: link.getAttribute("href"),
                        message: message,
                        title: link.getAttribute("data-confirm-title") || "Confirm Delete"
                    });
                    return;
                }
                link.classList.add("is-loading");
                link.setAttribute("aria-disabled", "true");
            });
        });

        document.addEventListener("keydown", function (event) {
            if (event.key === "Escape" && activeConfirm) {
                closeConfirmModal();
            }
            if (event.key === "Escape" && loanDialog && loanDialog.getAttribute("aria-hidden") === "false") {
                closeLoanModal();
            }
        });

        function openLoanModal() {
            if (!loanDialog) {
                return;
            }
            loanDialog.removeAttribute("hidden");
            loanDialog.setAttribute("aria-hidden", "false");
            document.body.classList.add("has-modal");
            var firstField = loanDialog.querySelector("form select, form input, form button");
            if (firstField) {
                firstField.focus();
            }
        }

        function closeLoanModal() {
            if (!loanDialog) {
                return;
            }
            loanDialog.setAttribute("aria-hidden", "true");
            loanDialog.setAttribute("hidden", "");
            document.body.classList.remove("has-modal");
        }

        if (openLoanDialog) {
            openLoanDialog.addEventListener("click", openLoanModal);
        }

        closeLoanDialog.forEach(function (button) {
            button.addEventListener("click", closeLoanModal);
        });

        if (loanDialog) {
            loanDialog.addEventListener("click", function (event) {
                if (event.target === loanDialog) {
                    closeLoanModal();
                }
            });
        }

        showFlashToast();
    }());
</script>
</body>
</html>
