// Student Dashboard JavaScript

document.addEventListener('DOMContentLoaded', function() {
    // Initialize tooltips
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });

    // Initialize progress tracking
    initializeProgressTracking();
    
    // Initialize course card interactions
    initializeCourseCards();
});

function initializeProgressTracking() {
    // Add click handlers for progress update buttons
    const progressButtons = document.querySelectorAll('[onclick*="updateProgress"]');
    progressButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();
            updateCourseProgress(this);
        });
    });
}

function initializeCourseCards() {
    // Add hover effects and interactions to course cards
    const courseCards = document.querySelectorAll('.course-card');
    courseCards.forEach(card => {
        card.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-5px)';
        });
        
        card.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0)';
        });
    });
}

function showCourseDetails(courseId) {
    const modal = document.getElementById('courseDetailsModal');
    const content = document.getElementById('courseDetailsContent');
    
    // Show loading state
    content.innerHTML = `
        <div class="text-center py-4">
            <div class="spinner-border text-primary" role="status">
                <span class="visually-hidden">Loading...</span>
            </div>
            <p class="mt-2 text-muted">Loading course details...</p>
        </div>
    `;
    
    // Show modal
    const bootstrapModal = new bootstrap.Modal(modal);
    bootstrapModal.show();
    
    // Load course details via AJAX
    fetch(`courseDetailsStudent.jsp?courseId=${courseId}`)
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.text();
        })
        .then(html => {
            content.innerHTML = html;
            
            // Reinitialize any Bootstrap components in the loaded content
            const accordionElements = content.querySelectorAll('.accordion');
            accordionElements.forEach(accordion => {
                new bootstrap.Collapse(accordion, {
                    toggle: false
                });
            });
        })
        .catch(error => {
            console.error('Error loading course details:', error);
            content.innerHTML = `
                <div class="text-center text-muted py-4">
                    <i class="bi bi-exclamation-triangle" style="font-size: 3rem;"></i>
                    <h5 class="mt-3">Error Loading Course Details</h5>
                    <p>Unable to load course information. Please try again later.</p>
                    <button class="btn btn-primary" onclick="showCourseDetails(${courseId})">
                        <i class="bi bi-arrow-clockwise me-2"></i>Retry
                    </button>
                </div>
            `;
        });
}

function markSectionComplete(sectionId) {
    const courseId = getCourseIdFromContext();
    if (!courseId) {
        console.error('Course ID not found');
        return;
    }
    
    // Show loading state
    const button = event.target.closest('button');
    const originalText = button.innerHTML;
    button.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Updating...';
    button.disabled = true;
    
    // Make AJAX call to mark section complete
    const formData = new FormData();
    formData.append('action', 'markSectionComplete');
    formData.append('courseId', courseId);
    formData.append('sectionId', sectionId);
    
    fetch('ProgressServlet', {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            // Update UI to show completion
            button.innerHTML = '<i class="bi bi-check-circle-fill me-2"></i>Completed';
            button.classList.remove('btn-outline-primary');
            button.classList.add('btn-success');
            button.disabled = true;
            
            // Update progress bar if available
            updateProgressBar(data.newProgress);
            
            // Show success message
            showToast('Section marked as complete!', 'success');
        } else {
            throw new Error('Failed to mark section complete');
        }
    })
    .catch(error => {
        console.error('Error marking section complete:', error);
        button.innerHTML = originalText;
        button.disabled = false;
        showToast('Failed to mark section complete. Please try again.', 'error');
    });
}

function updateCourseProgress(button) {
    const courseId = getCourseIdFromContext();
    if (!courseId) {
        console.error('Course ID not found');
        return;
    }
    
    // Show loading state
    const originalText = button.innerHTML;
    button.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Updating...';
    button.disabled = true;
    
    // Make AJAX call to update progress
    const formData = new FormData();
    formData.append('action', 'updateCourseProgress');
    formData.append('courseId', courseId);
    
    fetch('ProgressServlet', {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            // Update progress bar
            updateProgressBar(data.progress);
            
            // Update button text
            button.innerHTML = '<i class="bi bi-check-circle me-2"></i>Updated';
            setTimeout(() => {
                button.innerHTML = originalText;
                button.disabled = false;
            }, 2000);
            
            showToast(`Progress updated to ${data.progress}%`, 'success');
        } else {
            throw new Error('Failed to update progress');
        }
    })
    .catch(error => {
        console.error('Error updating progress:', error);
        button.innerHTML = originalText;
        button.disabled = false;
        showToast('Failed to update progress. Please try again.', 'error');
    });
}

function updateProgressBar(progress) {
    const progressBar = document.querySelector('.progress-bar');
    if (progressBar) {
        progressBar.style.width = `${progress}%`;
        progressBar.setAttribute('aria-valuenow', progress);
        
        // Update progress text
        const progressText = document.querySelector('.progress-percentage');
        if (progressText) {
            progressText.textContent = `${progress}%`;
        }
    }
}

function getCourseIdFromContext() {
    // Try to get course ID from various sources
    const urlParams = new URLSearchParams(window.location.search);
    const courseId = urlParams.get('courseId');
    
    if (courseId) {
        return courseId;
    }
    
    // Try to get from modal context
    const modal = document.getElementById('courseDetailsModal');
    if (modal && modal.dataset.courseId) {
        return modal.dataset.courseId;
    }
    
    return null;
}

function showToast(message, type = 'info') {
    // Create toast element
    const toastContainer = document.querySelector('.toast-container') || createToastContainer();
    
    const toastElement = document.createElement('div');
    toastElement.className = `toast align-items-center text-white bg-${type === 'error' ? 'danger' : type} border-0`;
    toastElement.setAttribute('role', 'alert');
    toastElement.setAttribute('aria-live', 'assertive');
    toastElement.setAttribute('aria-atomic', 'true');
    
    toastElement.innerHTML = `
        <div class="d-flex">
            <div class="toast-body">
                ${message}
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
    `;
    
    toastContainer.appendChild(toastElement);
    
    // Show toast
    const toast = new bootstrap.Toast(toastElement);
    toast.show();
    
    // Remove toast element after it's hidden
    toastElement.addEventListener('hidden.bs.toast', function() {
        toastElement.remove();
    });
}

function createToastContainer() {
    const container = document.createElement('div');
    container.className = 'toast-container position-fixed top-0 end-0 p-3';
    container.style.zIndex = '1055';
    document.body.appendChild(container);
    return container;
}

// Utility function to format dates
function formatDate(dateString) {
    const date = new Date(dateString);
    return date.toLocaleDateString('en-US', {
        year: 'numeric',
        month: 'short',
        day: 'numeric'
    });
}

// Utility function to format duration
function formatDuration(minutes) {
    const hours = Math.floor(minutes / 60);
    const mins = minutes % 60;
    
    if (hours > 0) {
        return `${hours}h ${mins}m`;
    }
    return `${mins}m`;
}

// Export functions for global access
window.showCourseDetails = showCourseDetails;
window.markSectionComplete = markSectionComplete;
window.updateCourseProgress = updateCourseProgress; 