<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Login - eLearning Platform</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="css/styles.css"> <link href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css" rel="stylesheet" />

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>

    <script src="js/scripts.js"></script>

    <style>
        /* Video Background Styling */
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
        .toast-container {
            z-index: 1050;
        }
        
        /* Body background set to pure white */
        body {
            background-color: #FFFFFF;
            min-height: 100vh;  
        }
        .themed-card{
            margin-top: 15%;
        }

        /* Styles for form elements to ensure visibility on the gradient background */
        /* Targets labels within the themed container */
        .themed-card .form-label {
            color: white;
            font-weight: 500; /* Slightly bolder for readability */
        }

        /* Targets input and select fields within the themed container */
        .themed-card .form-control,
        .themed-card .form-select {
            background-color: rgba(255, 255, 255, 0.15); /* Slightly transparent white */
            color: white; /* Text color inside input */
            border: 1px solid rgba(255, 255, 255, 0.4); /* Clearer border */
        }
        .themed-card .form-control::placeholder {
            color: rgba(255, 255, 255, 0.8); /* Darker white for placeholder */
        }
        .themed-card .form-control:focus,
        .themed-card .form-select:focus {
            background-color: rgba(255, 255, 255, 0.25);
            border-color: #ffffff;
            box-shadow: 0 0 0 0.25rem rgba(255, 255, 255, 0.25);
            color: white; /* Ensure text remains white on focus */
        }

        /* Specific style for dropdown options within the select */
        .themed-card .form-select option {
            /* This ensures the options themselves have a solid background, usually dark */
            background-color: #6f42c1; /* Match the primary gradient color */
            color: white;
        }

        /* Adjust button style to fit the new theme */
        .themed-card .btn-primary {
            background-color: #5a36a0; /* Slightly darker purple for button */
            border-color: #5a36a0;
            transition: background-color 0.2s ease;
        }
        .themed-card .btn-primary:hover {
            background-color: #4b2d86; /* Even darker on hover */
            border-color: #4b2d86;
        }

        /* Style for the main heading inside the themed card */
        .themed-card h2 {
            color: white; /* Ensure heading is white */
            margin-bottom: 1.5rem; /* Space below heading */
        }
        
        /* Overlay for video (optional, but good for readability) */
        .video-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.3); /* Semi-transparent black overlay */
            z-index: -99; /* Between video and content */
        }
        
        #account-btn{
            border-radius: 28px;
        }
    </style>
</head>
<body> 
        <video autoplay loop muted id="video-background">
         <source src="/img/videoBackground.mov" type="video/quicktime">
         Your browser does not support the video tag.
        </video>
        
    <div class="video-overlay"></div> 
    <div class="container" style="z-index: 1;">
    <div class="row justify-content-center">
        <div class="col-md-4 p-4 rounded shadow-lg themed-card"
             style="background: linear-gradient(to bottom right, #6f42c1, #CEFFCE);">

            <h2 class="text-center mb-4">eLearning Login</h2>
            <form action="LoginServlet" method="post">
                <div class="mb-3">
                    <label for="userEmail" class="form-label">User Email</label>
                    <input type="text" name="userEmail" class="form-control" required autofocus>
                </div>
                <div class="mb-3">
                    <label for="password" class="form-label">Password</label>
                    <input type="password" name="password" class="form-control" required>
                </div>
                <%
                    String error = request.getParameter("error");
                    if (error != null) {
                %>
                    <div class="alert alert-danger" role="alert">
                        Invalid username or password.
                    </div>
                <% } %>
                <div class="d-grid">
                    <button type="submit" class="btn btn-primary search-btn" id="account-btn">Login</button>
                </div>
            </form>
        </div>
    </div>
    </div>
</div>

<div class="toast-container position-fixed top-0 end-0 p-3">
        <div id="loginSuccessToast" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="toast-header">
                <strong class="me-auto">Success!</strong>
                <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
            <div class="toast-body" id="loginSuccessToastBody">
                </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const urlParams = new URLSearchParams(window.location.search);
            const successMessage = urlParams.get('msg');

            if (successMessage) {
                const toastElement = document.getElementById('loginSuccessToast');
                const toastBody = document.getElementById('loginSuccessToastBody');
                const toast = new bootstrap.Toast(toastElement);

                toastBody.textContent = decodeURIComponent(successMessage.replace(/\+/g, ' '));
                toastElement.classList.remove('bg-danger'); // Just in case
                toastElement.classList.add('bg-success', 'text-white'); // Green toast for success
                toast.show();

                // Clear URL parameters after showing toast to prevent re-showing on refresh
                history.replaceState({}, document.title, window.location.pathname);
            }
        });
    </script>

</body>
</html>