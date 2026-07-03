package lucky

import (
	"testing"
	"time"
)

func TestMemStore_CreateAndList(t *testing.T) {
	s := NewMemStore()

	c1, err := s.CreateCode("user-a", "￥abcd1234￥")
	if err != nil {
		t.Fatalf("create code: %v", err)
	}
	if c1.Status != StatusActive {
		t.Fatalf("expected active, got %s", c1.Status)
	}

	c2, err := s.CreateCode("user-b", "￥efgh5678￥")
	if err != nil {
		t.Fatalf("create code: %v", err)
	}

	resp, err := s.ListActive(1, 20)
	if err != nil {
		t.Fatalf("list active: %v", err)
	}
	list := resp.Data.([]LuckyCode)
	if len(list) != 2 {
		t.Fatalf("expected 2 codes, got %d", len(list))
	}
	// Newest first.
	if list[0].ID != c2.ID {
		t.Error("expected newest code first")
	}
}

func TestMemStore_CopyCode(t *testing.T) {
	s := NewMemStore()

	c, _ := s.CreateCode("user-a", "￥copy-me￥")

	// First copy succeeds.
	text, ok, err := s.CopyCode(c.ID, "user-b")
	if err != nil {
		t.Fatalf("copy: %v", err)
	}
	if !ok {
		t.Fatal("first copy should succeed")
	}
	if text != "￥copy-me￥" {
		t.Fatalf("wrong code text: %s", text)
	}

	// Second copy by different user fails (already copied).
	_, ok, _ = s.CopyCode(c.ID, "user-c")
	if ok {
		t.Fatal("second copy should fail")
	}

	// Same user re-copying fails (duplicate).
	_, ok, _ = s.CopyCode(c.ID, "user-b")
	if ok {
		t.Fatal("same-user duplicate should fail")
	}
}

func TestMemStore_DeleteCode(t *testing.T) {
	s := NewMemStore()
	c, _ := s.CreateCode("user-a", "￥del-me￥")

	deleted, err := s.DeleteCode(c.ID, "user-b")
	if err != nil {
		t.Fatalf("delete: %v", err)
	}
	if deleted {
		t.Fatal("delete by wrong user should fail")
	}

	deleted, err = s.DeleteCode(c.ID, "user-a")
	if err != nil {
		t.Fatalf("delete: %v", err)
	}
	if !deleted {
		t.Fatal("delete by owner should succeed")
	}
}

func TestMemStore_Mine(t *testing.T) {
	s := NewMemStore()
	c1, _ := s.CreateCode("user-a", "￥mine-1￥")
	c2, _ := s.CreateCode("user-a", "￥mine-2￥")
	s.CreateCode("user-b", "￥not-mine￥")

	// User-b copies user-a's first code.
	s.CopyCode(c1.ID, "user-b")

	resp, err := s.ListMine("user-a", 1, 20)
	if err != nil {
		t.Fatalf("list mine: %v", err)
	}
	items := resp.Data.([]MineItem)
	if resp.Total != 2 {
		t.Fatalf("expected total 2, got %d", resp.Total)
	}
	// Verify format.
	if resp.Page != 1 || resp.PageSize != 20 {
		t.Errorf("unexpected pagination: page=%d page_size=%d", resp.Page, resp.PageSize)
	}
	// All user-a items should have role=publisher.
	for _, item := range items {
		if item.Role != RolePublisher {
			t.Errorf("expected publisher role, got %s", item.Role)
		}
	}
	// Items should be in data array.
	if items[0].ID != c2.ID {
		t.Error("expected newest published first in data array")
	}

	respB, _ := s.ListMine("user-b", 1, 20)
	itemsB := respB.Data.([]MineItem)
	if respB.Total != 1 {
		t.Fatalf("expected total 1 for user-b, got %d", respB.Total)
	}
	if itemsB[0].Role != RoleCopier {
		t.Errorf("expected copier role, got %s", itemsB[0].Role)
	}
	if itemsB[0].CodeText != "￥mine-1￥" {
		t.Errorf("expected copied code text, got %s", itemsB[0].CodeText)
	}
}

func TestMemStore_ExpireCodes(t *testing.T) {
	s := NewMemStore()
	c, _ := s.CreateCode("user-a", "￥expire-me￥")
	// Manually set expired.
	c.ExpiredAt = c.ExpiredAt.Add(-25 * time.Hour)

	n, err := s.ExpireCodes()
	if err != nil {
		t.Fatalf("expire: %v", err)
	}
	if n != 1 {
		t.Fatalf("expected 1 expired, got %d", n)
	}
	resp, _ := s.ListActive(1, 20)
	list := resp.Data.([]LuckyCode)
	if len(list) != 0 {
		t.Fatalf("expected 0 active after expiry, got %d", len(list))
	}
}
