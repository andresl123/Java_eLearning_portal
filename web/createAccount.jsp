<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Create Account</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
      <!-- Our custom styles to make it pop -->
    <link rel="stylesheet" href="css/styles.css">
    <style>
        /* Body background set to pure white */
        body {
            background-color: #FFFFFF;
        }
        
        .toast-container {
            z-index: 1050; /* Ensure toast is above other elements */
        }
        
        #video-background {
            position: fixed; /* Fixes the video to the viewport */
            right: 0;
            bottom: 0;
            min-width: 100%; /* Ensures it covers the full width */
            min-height: 100%; /* Ensures it covers the full height */
            width: auto;
            height: auto;
            z-index: -100; /* Puts the video behind all other content */
            overflow: hidden; /* Hides overflow if video dimensions are larger than screen */
            background-size: cover; /* Ensures video scales to cover the area */
            /* Fallback background image in case video fails to load or is not supported */
            background-image: url('img/backgroundPic.png'); /* REPLACE with your fallback image */
            background-position: center center;
            background-repeat: no-repeat;
        }

        /* Styles for form elements to ensure visibility on the gradient background */
        .form-label {
            color: white;
            font-weight: 500; /* Slightly bolder for readability */
        }

        .form-control,
        .form-select {
            /* Using rgba for slightly transparent white input fields */
            background-color: rgba(255, 255, 255, 0.15); /* A bit more opaque than 0.1 for better visibility */
            color: white;
            border: 1px solid rgba(255, 255, 255, 0.4); /* Clearer border */
        }
        .form-control::placeholder {
            color: rgba(255, 255, 255, 0.8); /* Darker white for placeholder */
        }
        .form-control:focus,
        .form-select:focus {
            background-color: rgba(255, 255, 255, 0.25);
            border-color: #ffffff;
            box-shadow: 0 0 0 0.25rem rgba(255, 255, 255, 0.25);
            color: white; /* Ensure text remains white on focus */
        }

        /* Specific style for dropdown options within the select */
        .form-select option {
            /* This ensures the options themselves have a solid background, usually dark */
            background-color: #6f42c1; /* Match the primary gradient color */
            color: white;
        }

        /* Adjust button style to fit the new theme */
        .btn-primary {
            background-color: #5a36a0; /* Slightly darker purple for button */
            border-color: #5a36a0;
            transition: background-color 0.2s ease;
        }
        .btn-primary:hover {
            background-color: #4b2d86; /* Even darker on hover */
            border-color: #4b2d86;
        }
        
        #account-btn{
            border-radius: 28px;
        }
    </style>
    <script>
        function toggleTutorDescription() {
            const role = document.getElementById("roleName").value;
            const tutorDescDiv = document.getElementById("tutorDescDiv");
            tutorDescDiv.style.display = (role === "Tutor") ? "block" : "none";
        }
        window.onload = toggleTutorDescription;
    </script>
</head>
<body class="bg-light"> 
    <div class="container mt-5 p-4 rounded shadow-lg"
     style="background-color: #6f42c1; color: white; max-width: 500px; margin-left: auto; margin-right: auto;">
        
        <div id="video-background"></div>
        <h2>Create Account</h2>
            <form action="CreateAccountServlet" method="post">
                <div class="mb-3">
                    <label for="userName" class="form-label">First Name</label>
                    <input type="text" class="form-control" name="userName" required>
                </div>
                <div class="mb-3">
                    <label for="userLastName" class="form-label">Last Name</label>
                    <input type="text" class="form-control" name="userLastName" required>
                </div>
                <div class="mb-3">
                    <label for="userEmail" class="form-label">Email</label>
                    <input type="email" class="form-control" name="userEmail" required>
                </div>
                <div class="mb-3">
                    <label for="userPassword" class="form-label">Password</label>
                    <input type="password" class="form-control" name="userPassword" required>
                </div>
                <div class="mb-3">
                    <label for="roleName" class="form-label">Role</label>
                    <select class="form-select" id="roleName" name="roleName" onchange="toggleTutorDescription()" required>
                        <option value="Student">Student</option>
                        <option value="Tutor">Tutor</option>
                    </select>
                </div>
                <div class="mb-3" id="tutorDescDiv" style="display: none;">
                    <label for="tutorDesc" class="form-label">Tutor Description</label>
                    <input type="text" class="form-control" name="tutorDesc">
                </div>
                <button type="submit" class="btn btn-primary search-btn" id="account-btn">Create Account</button>
            </form>
    </div>
    <div class="toast-container position-fixed top-0 end-0 p-3">
        <div id="liveToast" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="toast-header">
                <strong class="me-auto">Notification</strong>
                <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
            <div class="toast-body" id="toastBody"></div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
   <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Get the error message passed from the servlet as a request attribute
            // This is for scenarios where the servlet *forwards* to the JSP (e.g., user exists)
            const errorMessage = "<%= request.getAttribute("error") != null ? request.getAttribute("error") : "" %>";

            const toastElement = document.getElementById('liveToast');
            const toastBody = document.getElementById('toastBody');
            const toast = new bootstrap.Toast(toastElement);

            if (errorMessage) {
                // Set the toast body text to the error message
                toastBody.textContent = errorMessage;
                // Add Bootstrap classes for a red, white-text error toast
                toastElement.classList.remove('bg-success'); // Ensure success styling is removed
                toastElement.classList.add('bg-danger', 'text-white');
                // Show the toast
                toast.show();
            }
        });
    </script>
</body>
</html>